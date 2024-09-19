import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/addbusHalt.dart';
import 'package:test_4/pages/SelectCurrentAdmin.dart';
import 'package:test_4/pages/Useless/adminreturntrip.dart';
import 'package:test_4/pages/displaySeats.dart';

class AdminPage extends StatefulWidget {
  final String? docID; // Receive the document ID from RegistrationListPage

  AdminPage({Key? key, this.docID}) : super(key: key);

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  final _formKey = GlobalKey<FormState>();
  String? busID;
  String? busName;
  String? routeNum;
  String? sourceLocation;
  String? destinationLocation;
  LatLng? _selectedLocation; // Store selected location
  List<Map<String, dynamic>> _busHalts = [];
  List<Map<String, String>> _timetableorg = []; // Timetable array
  bool? _hasReturnTrip; // Store return trip info
  String? userID; // User ID from Firestore
  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    _fetchBusData(); // Fetch data using the passed docID
  }

  Future<void> _fetchBusData() async {
    try {
      // Fetch the bus data using the docID from the registration collection
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('registration')
          .doc(widget.docID)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

        setState(() {
          busID = data['busID'];
          busName = data['busName'];
          routeNum = data['routeNum'];
          sourceLocation = data['sourceLocation'];
          destinationLocation = data['destinationLocation'];
          userID = data['userID']; // Get the userID to submit later
          _selectedLocation =
              data['latitude'] != null && data['longitude'] != null
                  ? LatLng(data['latitude'], data['longitude'])
                  : null;
          _busHalts = List<Map<String, dynamic>>.from(data['busHalts'] ?? []);

          // Handle timetable data properly with Map<String, dynamic>
          _timetableorg = List<Map<String, String>>.from(
            (data['timetableorg'] ?? []).map((item) => {
                  'departureTime': item['departureTime'].toString(),
                  'arrivalTime': item['arrivalTime'].toString(),
                }),
          );

          _hasReturnTrip = data['hasReturnTrip'];
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
        title: Text('Add Bus Details'),
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
                      _buildTextFormField(
                          'Destination Location',
                          destinationLocation,
                          (value) => destinationLocation = value),

                      SizedBox(height: 20),

                      // Directly display the fetched timetable
                      _timetableorg.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Timetable:',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                ..._timetableorg.map((entry) {
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

                      // Add Seats button
                      ElevatedButton(
                        onPressed: () async {
                          if (widget.docID != null) {
                            // Pass the docID to DisplaySeats page
                            await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DisplaySeats(docID: widget.docID!), // Ensure docID is passed
                              ),
                            );
                          } else {
                            // Show an error message if the docID is null
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Document ID is not available. Cannot proceed to add seats.')),
                            );
                          }
                        },
                        child: Text('Add Seats'),
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

                      // Return Trip Check
                      SizedBox(height: 20),
                      _buildReturnTripCheck(),

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

  // Build Return Trip Check
  Widget _buildReturnTripCheck() {
    if (_hasReturnTrip == null) return Container();

    if (_hasReturnTrip == false) {
      return Text(
        'Has a return trip: No',
        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
      );
    } else {
      return ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => returnTrip(busID: widget.docID)),
          );
        },
        child: Text('Add the return bus'),
      );
    }
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
          .collection('buses')
          .add({
        'busID': busID,
        'busName': busName,
        'routeNum': routeNum,
        'sourceLocation': sourceLocation,
        'destinationLocation': destinationLocation,
        'latitude': _selectedLocation?.latitude,
        'longitude': _selectedLocation?.longitude,
        'busHalts': _busHalts,
        'isOnline': false,
        'timetableorg': _timetableorg,
        'hasReturnTrip': _hasReturnTrip,
      }).then((_) {
        // Update 'isadd' to true in the registration collection
        FirebaseFirestore.instance
            .collection('registration')
            .doc(widget.docID)
            .update({'isadd': true});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bus added successfully')),
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
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add bus: $error')),
        );
      });
    }
  }
}
