import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:test_4/pages/Driver/busmap_driver.dart';
import 'package:test_4/pages/Driver/editbusdetails_driver.dart';

class BusDetailsPage extends StatefulWidget {
  final String busId;
  final String userID;

  BusDetailsPage({required this.busId, required this.userID});

  @override
  _BusDetailsPageState createState() => _BusDetailsPageState();
}

class _BusDetailsPageState extends State<BusDetailsPage> {
  Location _locationController = Location();
  StreamSubscription<LocationData>? _locationSubscription; // For selected bus
  StreamSubscription<LocationData>?
      _returnTripLocationSubscription; // For return trip
  DocumentSnapshot? busData;
  bool isOnline = false;
  bool hasReturnTrip = false;
  bool isReturnTripActive = false; // For the toggle button state
  String destinationLocation = '';
  String sourceLocation = '';
  List<Map<String, String>> _timetable = []; // Timetable array for return trip

  @override
  void initState() {
    super.initState();
    _loadBusData(); // Load bus data initially
  }

  Future<void> _loadBusData() async {
    try {
      // Fetch the specific bus data from Firestore
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection('driver')
          .doc(widget.userID)
          .collection('buses')
          .doc(widget.busId)
          .get();

      setState(() {
        busData = data;
        isOnline = busData!['isOnline'] ?? false;
        hasReturnTrip = busData!['hasReturnTrip'] ?? false;
        destinationLocation = busData!['destinationLocation'] ?? '';
        sourceLocation = busData!['sourceLocation'] ?? '';
        // Fetch timetable for return trip (replace timetableorg with timetable)
        _timetable = (data['timetable'] != null)
            ? List<Map<String, String>>.from(
                (data['timetable'] as List).map((item) => {
                      'departureTime': item['departureTime'].toString(),
                      'arrivalTime': item['arrivalTime'].toString(),
                    }),
              )
            : (data['timetableorg'] != null)
                ? List<Map<String, String>>.from(
                    (data['timetableorg'] as List).map((item) => {
                          'departureTime': item['departureTime'].toString(),
                          'arrivalTime': item['arrivalTime'].toString(),
                        }),
                  )
                : [];
      });
    } catch (e) {
      print("Error fetching bus data: $e");
    }
  }

  void _toggleOnlineStatus() async {
    if (isOnline) {
      _stopSelectedBusLocationUpdates();
      await FirebaseFirestore.instance
          .collection('driver')
          .doc(widget.userID)
          .collection('buses')
          .doc(widget.busId)
          .update({'isOnline': false});
      setState(() {
        isOnline = false;
      });
    } else {
      bool canGoOnline = await _startSelectedBusLocationUpdates();
      if (canGoOnline) {
        await FirebaseFirestore.instance
            .collection('driver')
            .doc(widget.userID)
            .collection('buses')
            .doc(widget.busId)
            .update({'isOnline': true});
        setState(() {
          isOnline = true;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Location permission is required to go online.'),
          ),
        );
      }
    }
  }

  Future<bool> _startSelectedBusLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check and request location permissions
    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return false;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return false;
      }
    }

    _locationSubscription = _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        FirebaseFirestore.instance
            .collection('driver')
            .doc(widget.userID)
            .collection('buses')
            .doc(widget.busId)
            .update({
          'latitude': currentLocation.latitude,
          'longitude': currentLocation.longitude,
        });
      }
    });

    return true;
  }

  Future<void> _startReturnTripLocationUpdates() async {
    _returnTripLocationSubscription = _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        _updateReturnTripBusLocation(
            currentLocation.latitude!, currentLocation.longitude!);
      }
    });
  }

  void _stopSelectedBusLocationUpdates() {
    _locationSubscription?.cancel();
  }

  void _stopReturnTripLocationUpdates() {
    _returnTripLocationSubscription?.cancel();
  }

  Future<void> _updateReturnTripBusLocation(
      double latitude, double longitude) async {
    try {
      // Search for the bus with the same busID, but a different document ID
      QuerySnapshot buses = await FirebaseFirestore.instance
          .collection('driver')
          .doc(widget.userID)
          .collection('buses')
          .where('busID', isEqualTo: busData!['busID'])
          .where(FieldPath.documentId, isNotEqualTo: widget.busId)
          .get();

      if (buses.docs.isNotEmpty) {
        // Update latitude and longitude of the found bus
        buses.docs.forEach((doc) {
          doc.reference.update({
            'latitude': latitude,
            'longitude': longitude,
          });
        });
      }
    } catch (e) {
      print("Error updating return trip bus location: $e");
    }
  }

  Future<bool> _onWillPop() async {
    if (isOnline) {
      return await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Exit Tracking?'),
              content: Text(
                  'Are you sure you want to exit? The tracking will stop if you exit.'),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('No'),
                ),
                TextButton(
                  onPressed: () async {
                    // Change online status to false and update Firestore
                    await FirebaseFirestore.instance
                        .collection('driver')
                        .doc(widget.userID)
                        .collection('buses')
                        .doc(widget.busId)
                        .update({'isOnline': false});

                    setState(() {
                      isOnline = false;
                    });

                    // Close the dialog and allow back navigation
                    Navigator.of(context).pop(true);
                  },
                  child: Text('Yes'),
                ),
              ],
            ),
          ) ??
          false;
    } else {
      return true; // Allow back navigation if offline
    }
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    _returnTripLocationSubscription?.cancel();
    super.dispose();
  }

  Future<void> _updateReturnTripStatus(bool status) async {
    try {
      // Find the return trip bus document (different document with the same busID)
      QuerySnapshot buses = await FirebaseFirestore.instance
          .collection('driver')
          .doc(widget.userID)
          .collection('buses')
          .where('busID', isEqualTo: busData!['busID'])
          .where(FieldPath.documentId, isNotEqualTo: widget.busId)
          .get();

      if (buses.docs.isNotEmpty) {
        // Update 'onWay' and 'isOnline' for the return trip bus document
        buses.docs.forEach((doc) {
          doc.reference.update({
            'onWay': status,
            'isOnline': status,
          });
        });
      }
    } catch (e) {
      print("Error updating return trip status: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: isOnline ? Colors.green : Colors.red,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Bus Details'),
              IconButton(
                icon: Icon(Icons.refresh),
                onPressed: _loadBusData,
              ),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditBusDetails(
                          busId: widget.busId, userID: widget.userID),
                    ),
                  );
                  if (result == true) {
                    _loadBusData();
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlue,
                ),
                child: Text('Edit'),
              ),
            ],
          ),
        ),
        body: busData == null
            ? Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bus Name: ${busData!['busName']}',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text('Route Number: ${busData!['routeNum']}',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text('Source Location: $sourceLocation',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text('Destination Location: $destinationLocation',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 20),
                    Text('Bus Halts:', style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Container(
                      height: 200,
                      child: ListView.builder(
                        itemCount: busData!['busHalts']?.length ?? 0,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(busData!['busHalts'][index]['name']),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 20),

                    // Display the timetable for return trip
                    _timetable.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Timetable:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              ..._timetable.map((entry) {
                                return Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                        'Departure: ${entry['departureTime'] ?? ''}'),
                                    Text(
                                        'Arrival: ${entry['arrivalTime'] ?? ''}'),
                                  ],
                                );
                              }).toList(),
                            ],
                          )
                        : Text('No timetable available'),

                    SizedBox(height: 10),
                    if (isOnline)
                      Container(
                        padding: EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                          color: Colors.green[100],
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          'You are Online, Your bus is tracking to passengers',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.green[800],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusLocationMapPage(
                              busId: widget.busId,
                              userID: widget.userID,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.lightBlue,
                      ),
                      child: Text('View on Google Maps'),
                    ),

                    // "Go online" toggle button
                    ElevatedButton(
                      onPressed: _toggleOnlineStatus,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: isOnline ? Colors.red : Colors.green,
                      ),
                      child: Text(isOnline ? 'Go Offline' : 'Go Online'),
                    ),
                    SizedBox(height: 10),

                    // Return Trip toggle
                    if (hasReturnTrip)
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Return Trip',
                            style: TextStyle(fontSize: 18),
                          ),
                          Switch(
                            value: isReturnTripActive,
                            onChanged: (value) async {
                              setState(() {
                                isReturnTripActive = value;
                              });

                              if (isReturnTripActive) {
                                // Start updating the location for the return trip
                                _startReturnTripLocationUpdates();

                                // Set 'onWay' and 'isOnline' to true for the return trip bus document
                                await _updateReturnTripStatus(true);
                              } else {
                                // Stop updating the location for the return trip
                                _stopReturnTripLocationUpdates();

                                // Set 'onWay' and 'isOnline' to false for the return trip bus document
                                await _updateReturnTripStatus(false);
                              }
                            },
                          ),
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }
}
