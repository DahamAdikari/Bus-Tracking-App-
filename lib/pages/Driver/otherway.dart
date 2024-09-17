import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/addbusHalt.dart';
import 'package:test_4/pages/SelectCurrentAdmin.dart';
import 'package:intl/intl.dart'; // Add this for time formatting

class AddBusPage extends StatefulWidget {
  final String userID;
  final String busID;
  final String busName;
  final String routeNum;
  final String sourceLocation;
  final String destinationLocation;
  final List<Map<String, String>> timetable_org; // Added timetableOrg parameter

  AddBusPage({
    required this.userID,
    required this.busID,
    required this.busName,
    required this.routeNum,
    required this.sourceLocation,
    required this.destinationLocation,
    required this.timetable_org,
  });

  @override
  _AddBusPageState createState() => _AddBusPageState();
}

class _AddBusPageState extends State<AddBusPage> {
  LatLng? _selectedLocation;
  List<Map<String, dynamic>> _busHalts = [];
  bool hasReturnTrip = false; // Checkbox state
  List<Map<String, dynamic>> _timetable = []; // To store timetable entries

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bus Stops and Location'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
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
              CheckboxListTile(
                title: Text(
                    'Do you also have a turn from ${widget.destinationLocation} to ${widget.sourceLocation}?'),
                value: hasReturnTrip,
                onChanged: (bool? value) {
                  setState(() {
                    hasReturnTrip = value ?? false;
                  });
                },
              ),
              if (hasReturnTrip) ...[
                SizedBox(height: 20),
                Text('Timetable',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                _buildTimetable(),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addTimetableRow,
                  child: Text('Add Timetable Row'),
                ),
              ],
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
                onPressed: _submitBus,
                child: Text('Add Bus'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget to build timetable input section
  Widget _buildTimetable() {
    return Column(
      children: _timetable.map((entry) {
        int index = _timetable.indexOf(entry);
        return Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _timetable[index]['departureTime'] =
                          _formatTimeOfDay(pickedTime);
                    });
                  }
                },
                child: Text(
                  entry['departureTime'].isNotEmpty
                      ? entry['departureTime']
                      : 'Select Departure Time',
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                onPressed: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _timetable[index]['arrivalTime'] =
                          _formatTimeOfDay(pickedTime);
                    });
                  }
                },
                child: Text(
                  entry['arrivalTime'].isNotEmpty
                      ? entry['arrivalTime']
                      : 'Select Arrival Time',
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  _timetable.removeAt(index);
                });
              },
            ),
          ],
        );
      }).toList(),
    );
  }

  // Helper function to format TimeOfDay to a string (e.g., 'HH:mm')
  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat(
        'HH:mm'); // Use any format you want (e.g., 'HH:mm a' for AM/PM)
    return format.format(dt);
  }

  // Add new timetable row
  void _addTimetableRow() {
    setState(() {
      _timetable.add({
        'departureTime': '',
        'arrivalTime': '',
      });
    });
  }

  // Submit bus details to Firestore
  void _submitBus() {
    FirebaseFirestore.instance.collection('registration').add({
      'userID': widget.userID,
      'busID': widget.busID,
      'busName': widget.busName,
      'routeNum': widget.routeNum,
      'sourceLocation': widget.sourceLocation,
      'destinationLocation': widget.destinationLocation,
      'latitude': _selectedLocation?.latitude,
      'longitude': _selectedLocation?.longitude,
      'busHalts': _busHalts,
      'timetableorg': widget.timetable_org,
      'hasReturnTrip': hasReturnTrip, // Store the checkbox value
      'timetable': hasReturnTrip
          ? _timetable
          : [], // Store timetable only if return trip is selected
      'isOnline': false,
      'createdAt': FieldValue.serverTimestamp(), // Add createdAt field
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bus added successfully')),
      );
      Navigator.pop(context); // Return to the previous screen
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add bus: $error')));
    });
  }
}
