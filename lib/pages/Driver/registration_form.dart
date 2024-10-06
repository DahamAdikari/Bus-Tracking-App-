import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/pages/Driver/MapSelection.dart';

import './otherway.dart';

class RegistrationPageClass extends StatefulWidget {
  final String userID;

  RegistrationPageClass({required this.userID});

  @override
  RegistrationPage createState() => RegistrationPage();
}

class RegistrationPage extends State<RegistrationPageClass> {
  final _formKey = GlobalKey<FormState>();
  List<Map<String, String>> _timetable = [
    {'departureTime': '', 'arrivalTime': ''}
  ]; // Default timetable

  String? busID;
  String? busName;
  String? routeNum;
  String? numberPlate;
  LatLng? sourceLocationLatLng;
  LatLng? destinationLocationLatLng;
  String? sourceLocation;
  String? destinationLocation;

  late String userID;

  @override
  void initState() {
    super.initState();
    userID = widget.userID;
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
                  decoration: InputDecoration(labelText: 'Number Plate'),
                  onSaved: (value) {
                    numberPlate = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the number plate';
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
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    final LatLng? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GoogleMapPage(), // Page for selecting source location
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        sourceLocationLatLng = result;
                      });
                    }
                  },
                  child: Text('Select Source Location'),
                ),
                if (sourceLocationLatLng != null)
                  Text(
                      'Source: ${sourceLocationLatLng!.latitude}, ${sourceLocationLatLng!.longitude}'),
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
                ElevatedButton(
                  onPressed: () async {
                    final LatLng? result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GoogleMapPage(), // Page for selecting destination location
                      ),
                    );

                    if (result != null) {
                      setState(() {
                        destinationLocationLatLng = result;
                      });
                    }
                  },
                  child: Text('Select Destination Location'),
                ),
                if (destinationLocationLatLng != null)
                  Text(
                      'Destination: ${destinationLocationLatLng!.latitude}, ${destinationLocationLatLng!.longitude}'),
                SizedBox(height: 20),
                Text('Timetable',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                _buildTimetable(),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addTimetableRow,
                  child: Text('Add Timetable Row'),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate() &&
                        sourceLocationLatLng != null &&
                        destinationLocationLatLng != null) {
                      _formKey.currentState!.save();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddBusPage(
                            userID: userID,
                            busID: busID!,
                            busName: busName!,
                            routeNum: routeNum!,
                            sourceLocationLatLng: sourceLocationLatLng!,
                            destinationLocationLatLng:
                                destinationLocationLatLng!,
                            numberPlate: numberPlate!,
                            sourceLocation: sourceLocation!,
                            destinationLocation: destinationLocation!,
                            timetable_org: _timetable,
                          ),
                        ),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                            content: Text(
                                'Please select source and destination locations')),
                      );
                    }
                  },
                  child: Text('Next'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTimetable() {
    return Column(
      children: _timetable.map((entry) {
        int index = _timetable.indexOf(entry);
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(labelText: 'Departure Time'),
                controller: TextEditingController(text: entry['departureTime']),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _timetable[index]['departureTime'] =
                          _formatTime(pickedTime);
                    });
                  }
                },
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                readOnly: true,
                decoration: InputDecoration(labelText: 'Arrival Time'),
                controller: TextEditingController(text: entry['arrivalTime']),
                onTap: () async {
                  TimeOfDay? pickedTime = await showTimePicker(
                    context: context,
                    initialTime: TimeOfDay.now(),
                  );
                  if (pickedTime != null) {
                    setState(() {
                      _timetable[index]['arrivalTime'] =
                          _formatTime(pickedTime);
                    });
                  }
                },
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

  void _addTimetableRow() {
    setState(() {
      _timetable.add({
        'departureTime': '',
        'arrivalTime': '',
      });
    });
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formattedTime =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return formattedTime;
  }
}
