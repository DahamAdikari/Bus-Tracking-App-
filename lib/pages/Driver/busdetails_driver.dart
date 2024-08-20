import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';
import 'package:test_4/pages/Driver/busmap_driver.dart';
import 'package:test_4/pages/Driver/editbusdetails_driver.dart';

class BusDetailsPage extends StatefulWidget {
  final String busId;

  BusDetailsPage({required this.busId});

  @override
  _BusDetailsPageState createState() => _BusDetailsPageState();
}

class _BusDetailsPageState extends State<BusDetailsPage> {
  Location _locationController = Location();
  StreamSubscription<LocationData>? _locationSubscription;
  DocumentSnapshot? busData;
  bool isOnline = false;

  @override
  void initState() {
    super.initState();
    _loadBusData(); // Initial data load
  }

  Future<void> _loadBusData() async {
    try {
      DocumentSnapshot data = await FirebaseFirestore.instance
          .collection('buses')
          .doc(widget.busId)
          .get();
      setState(() {
        busData = data;
        isOnline = busData!['isOnline'] ?? false; // Initialize the online state
      });
    } catch (e) {
      // Handle any errors
      print("Error fetching bus data: $e");
    }
  }

  void _toggleOnlineStatus() async {
    if (isOnline) {
      // Go offline
      _locationSubscription?.cancel();
      await FirebaseFirestore.instance
          .collection('buses')
          .doc(widget.busId)
          .update({'isOnline': false});
      setState(() {
        isOnline = false;
      });
    } else {
      // Go online
      await _startLocationUpdates();
      await FirebaseFirestore.instance
          .collection('buses')
          .doc(widget.busId)
          .update({'isOnline': true});
      setState(() {
        isOnline = true;
      });
    }
  }

  Future<void> _startLocationUpdates() async {
    bool _serviceEnabled;
    PermissionStatus _permissionGranted;

    // Check and request location permissions
    _serviceEnabled = await _locationController.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _locationController.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Listen to location changes and update the database
    _locationSubscription = _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        FirebaseFirestore.instance
            .collection('buses')
            .doc(widget.busId)
            .update({
          'latitude': currentLocation.latitude,
          'longitude': currentLocation.longitude,
        });
      }
    });
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
                  onPressed: () => Navigator.of(context).pop(true),
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
    super.dispose();
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
                      builder: (context) => EditBusDetails(busId: widget.busId),
                    ),
                  );
                  if (result == true) {
                    // Refresh data after returning from edit page
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
                    Text('Source Location: ${busData!['sourceLocation']}',
                        style: TextStyle(fontSize: 18)),
                    SizedBox(height: 10),
                    Text(
                        'Destination Location: ${busData!['destinationLocation']}',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => BusLocationMapPage(
                                  busId: widget.busId,
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
                        ElevatedButton(
                          onPressed: _toggleOnlineStatus,
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor:
                                isOnline ? Colors.red : Colors.green,
                          ),
                          child: Text(isOnline ? 'Go Offline' : 'Go Online'),
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
