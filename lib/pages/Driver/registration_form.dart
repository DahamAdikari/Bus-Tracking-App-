import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/addbusHalt.dart';
import 'package:test_4/pages/Driver/Reg_seats.dart';
import 'package:test_4/pages/SelectCurrentAdmin.dart';

class RegistrationPageClass extends StatefulWidget {
  final String userID; // Line to receive the UID

  RegistrationPageClass(
      {required this.userID}); // Modify constructor to accept UID

  @override
  RegistrationPage createState() => RegistrationPage();
}

class RegistrationPage extends State<RegistrationPageClass> {
  final _formKey = GlobalKey<FormState>();

  String? busID;
  String? busName;
  String? routeNum;
  String? sourceLocation;
  String? destinationLocation;
  LatLng? _selectedLocation; // Store selected location
  List<Map<String, dynamic>> _busHalts = [];

  late String userID;

  @override
  void initState() {
    super.initState();
    userID = widget.userID; // Initialize userID with value from widget
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bus Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Bus ID'),
                  onSaved: (value) {
                    busID = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid bus ID';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Bus Name'),
                  onSaved: (value) {
                    busName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the bus name';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Route Number'),
                  onSaved: (value) {
                    routeNum = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the route number';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Source Location'),
                  onSaved: (value) {
                    sourceLocation = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the source location';
                    }
                    return null;
                  },
                ),
                TextFormField(
                  decoration:
                      InputDecoration(labelText: 'Destination Location'),
                  onSaved: (value) {
                    destinationLocation = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the destination location';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
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
                SizedBox(height: 20),
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
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue, // Set button color to blue
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RegSeats(), // Navigate to RegSeats
                      ),
                    );
                  },
                  child: Text(
                    'Add Seats',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                if (_selectedLocation != null)
                  Text(
                      'Selected Location: Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}'),
                SizedBox(height: 20),
                Text(
                  'Bus Halts:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
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
                SizedBox(height: 20),
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      FirebaseFirestore.instance.collection('registration').add({
        'userID': userID, // Add userID
        'busID': busID,
        'busName': busName,
        'routeNum': routeNum,
        'sourceLocation': sourceLocation,
        'destinationLocation': destinationLocation,
        'latitude': _selectedLocation?.latitude, // Store latitude
        'longitude': _selectedLocation?.longitude, // Store longitude
        'busHalts': _busHalts,
      }).then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Bus added successfully')),
        );

        // Clear the form and reset state
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
