import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/addbusHalt.dart';
import 'package:test_4/pages/Driver/MapSelection.dart';
import 'package:test_4/pages/SelectCurrentAdmin.dart';

class returnTrip extends StatefulWidget {
  final String? busID;

  returnTrip({
    required this.busID, //this is really the docID
  });

  @override
  _returnTripState createState() => _returnTripState();
}

class _returnTripState extends State<returnTrip> {
  final _formKey = GlobalKey<FormState>();
  String? busID;
  String? busName;
  String? routeNum;
  String? sourceLocation;
  String? destinationLocation;
  LatLng? _selectedLocation; // Store selected location
  List<Map<String, dynamic>> _busHalts = [];
  List<Map<String, String>> _timetable = []; // Timetable array for return trip
  String? userID; // User ID from Firestore
  bool _isLoading = true; // Track loading state
  bool? _hasReturnTrip;
  List<dynamic>? _seatLayout;
  int? _rows;
  int? _seatCount;
  int? _selectedModel;
  bool? bookingAvailable;
  String? numberPlate;
  LatLng? sourceLatLng; // Store source location LatLng
  LatLng? destinationLatLng; // Store destination location LatLng
  String? ticketPrice; // Store ticket price

  @override
  void initState() {
    super.initState();
    _fetchBusData(); // Fetch data using the busID
  }

  Future<void> _fetchBusData() async {
    try {
      // Fetch the bus data using the busID from the registration collection
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('registration')
          .doc(widget.busID)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

        setState(() {
          busID = data['busID'];
          busName = data['busName'];
          routeNum = data['routeNum'];
          numberPlate = data['numberPlate']; // Fetch numberPlate
          ticketPrice = data['ticketPrice']; // Fetch ticketPrice
          // Swap source and destination locations
          sourceLocation = data['destinationLocation'];
          destinationLocation = data['sourceLocation'];
          // Source and Destination LatLng
          if (data['destinationLatLng'] != null) {
            sourceLatLng = LatLng(data['destinationLatLng']['latitude'],
                data['destinationLatLng']['longitude']);
          }
          if (data['sourceLatLng'] != null) {
            destinationLatLng = LatLng(data['sourceLatLng']['latitude'],
                data['sourceLatLng']['longitude']);
          }

          userID = data['userID']; // Get the userID to submit later
          _selectedLocation =
              data['latitude'] != null && data['longitude'] != null
                  ? LatLng(data['latitude'], data['longitude'])
                  : null;
          _busHalts = List<Map<String, dynamic>>.from(data['busHalts'] ?? []);

          // Fetch timetable for return trip (replace timetableorg with timetable)
          _timetable = List<Map<String, String>>.from(
            (data['timetable'] ?? []).map((item) => {
                  'departureTime': item['departureTime'].toString(),
                  'arrivalTime': item['arrivalTime'].toString(),
                }),
          );
          _hasReturnTrip = data['hasReturnTrip'];
          bookingAvailable = data['bookingAvailable'];

          _seatLayout = data['seatData']['seatLayout'];
          _rows = data['seatData']['rows'];
          _seatCount = data['seatData']['seatCount'];
          _selectedModel = data['seatData']['selectedModel'];
        });
      }
    } catch (e) {
      print('Error fetching bus data: $e');
    } finally {
      setState(() {
        _isLoading = false; // Stop loading once data is fetched
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Return Bus Details'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildTextFormField(
                          'Bus ID', busID, (value) => busID = value),
                      _buildTextFormField(
                          'Bus Name', busName, (value) => busName = value),
                      _buildTextFormField('Route Number', routeNum,
                          (value) => routeNum = value),
                      _buildTextFormField('Source Location', sourceLocation,
                          (value) => sourceLocation = value),
                      // Button for changing the Source Location
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GoogleMapPage(), // Navigate to GoogleMapPage
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              sourceLatLng = result; // Update source location
                            });
                          }
                        },
                        child: Text('Edit Source Location'),
                      ),
                      if (sourceLatLng != null)
                        Text(
                            'Source Location: Lat: ${sourceLatLng!.latitude}, Lng: ${sourceLatLng!.longitude}'),
                      _buildTextFormField(
                          'Destination Location',
                          destinationLocation,
                          (value) => destinationLocation = value),
                      // Button for changing the Destination Location
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  GoogleMapPage(), // Navigate to GoogleMapPage
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              destinationLatLng =
                                  result; // Update destination location
                            });
                          }
                        },
                        child: Text('Edit Destination Location'),
                      ),
                      if (destinationLatLng != null)
                        Text(
                            'Destination Location: Lat: ${destinationLatLng!.latitude}, Lng: ${destinationLatLng!.longitude}'),
                      _buildTextFormField('Number Plate', numberPlate,
                          (value) => numberPlate = value),
                      _buildTextFormField('Ticket Price', ticketPrice,
                          (value) => ticketPrice = value),

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

                      SizedBox(height: 20),

                      // Add Bus Halt Button
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddBusHaltPage(),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              _busHalts.add({
                                'name': result['name'],
                                'location': {
                                  'latitude': result['location'].latitude,
                                  'longitude': result['location'].longitude,
                                },
                              });
                            });
                          }
                        },
                        child: Text('Add Bus Halt'),
                      ),

                      // Add Current Location Button
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SelectCurrentLocationPage(),
                            ),
                          );

                          if (result != null) {
                            setState(() {
                              _selectedLocation = result;
                            });
                          }
                        },
                        child: Text('Add Current Location of the Bus'),
                      ),
                      if (_selectedLocation != null)
                        Text(
                            'Selected Location: Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}'),

                      SizedBox(height: 20),

                      // Auto-display Bus Halts
                      _buildBusHalts(),

                      // Add Bus Button
                      ElevatedButton(
                        onPressed: _submitForm,
                        child: Text('Add Bus'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }

  // Build Bus Halts List
  Widget _buildBusHalts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bus Halts:', style: TextStyle(fontWeight: FontWeight.bold)),
        ..._busHalts.map((halt) {
          final location = halt['location'];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(halt['name']),
              Text(
                  'Lat: ${location['latitude']}, Lng: ${location['longitude']}'),
            ],
          );
        }).toList(),
      ],
    );
  }

  // Common text form field builder
  Widget _buildTextFormField(
      String label, String? initialValue, Function(String?) onSaved) {
    return TextFormField(
      initialValue: initialValue,
      decoration: InputDecoration(labelText: label),
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a valid $label';
        }
        return null;
      },
    );
  }

  // Submit form data to Firebase
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      FirebaseFirestore.instance
          .collection('driver')
          .doc(userID) // Use userID fetched from the registration document
          .collection('buses') // Use a different collection for return buses
          .add({
        'busID': busID,
        'busName': busName,
        'routeNum': routeNum,
        'numberPlate': numberPlate, // Include numberPlate
        'ticketPrice': ticketPrice, // Include ticketPrice
        'sourceLocation': sourceLocation,
        'destinationLocation': destinationLocation,
        'latitude': _selectedLocation?.latitude,
        'longitude': _selectedLocation?.longitude,
        'sourceLatLng': {
          'latitude': sourceLatLng?.latitude,
          'longitude': sourceLatLng?.longitude,
        }, // Include sourceLatLng
        'destinationLatLng': {
          'latitude': destinationLatLng?.latitude,
          'longitude': destinationLatLng?.longitude,
        }, // Include destinationLatLng
        'busHalts': _busHalts,
        'isOnline': false,
        'timetable': _timetable, // Push timetable instead of timetableorg
        'hasReturnTrip': _hasReturnTrip,
        'onWay': false,
        'timetableorg': null,
        'seatData': {
          'seatLayout': _seatLayout,
          'rows': _rows,
          'seatCount': _seatCount,
          'selectedModel': _selectedModel,
        },
        'bookingAvailable': bookingAvailable,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Return bus added successfully')),
        );

        _formKey.currentState!.reset();
        setState(() {
          busID = null;
          busName = null;
          routeNum = null;
          sourceLocation = null;
          destinationLocation = null;
          _selectedLocation = null;
          _busHalts.clear();
          _seatLayout = null;
          _rows = null;
          _seatCount = null;
          _selectedModel = null;
          bookingAvailable = null;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add return bus: $error')),
        );
      });
    }
  }
}
