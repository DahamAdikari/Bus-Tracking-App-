import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/addbusHalt.dart';
import 'package:test_4/pages/SelectCurrentAdmin.dart';

class AdminPage extends StatefulWidget {
  final Map<String, dynamic>? data; // Receive data from RegistrationListPage

  AdminPage({Key? key, this.data}) : super(key: key);

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

  @override
  void initState() {
    super.initState();

    if (widget.data != null) {
      busID = widget.data!['busID'];
      busName = widget.data!['busName'];
      routeNum = widget.data!['routeNum'];
      sourceLocation = widget.data!['sourceLocation'];
      destinationLocation = widget.data!['destinationLocation'];
      _selectedLocation =
          widget.data!['latitude'] != null && widget.data!['longitude'] != null
              ? LatLng(widget.data!['latitude'], widget.data!['longitude'])
              : null;
      _busHalts =
          List<Map<String, dynamic>>.from(widget.data!['busHalts'] ?? []);
    }
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
                  initialValue: busID,
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
                  initialValue: busName,
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
                  initialValue: routeNum,
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
                  initialValue: sourceLocation,
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
                  initialValue: destinationLocation,
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

      FirebaseFirestore.instance
          .collection('driver')
          .doc('BfVpZVAWiMMGbQj2Uohdm2COaUG2')
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
      }).then((_) {
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
