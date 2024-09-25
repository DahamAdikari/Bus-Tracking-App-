import 'package:flutter/material.dart';
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
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddBusPage(
                            userID: userID,
                            busID: busID!,
                            busName: busName!,
                            routeNum: routeNum!,
                            sourceLocation: sourceLocation!,
                            destinationLocation: destinationLocation!,
                            timetable_org:
                                _timetable, // Pass timetable to the next page
                          ),
                        ),
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

  // Widget to build timetable input section
  Widget _buildTimetable() {
    return Column(
      children: _timetable.map((entry) {
        int index = _timetable.indexOf(entry);
        return Row(
          children: [
            Expanded(
              child: TextFormField(
                readOnly:
                    true, // Make it read-only so the user can't type directly
                decoration: InputDecoration(labelText: 'Departure Time'),
                controller: TextEditingController(
                    text: entry['departureTime']), // Display selected time
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
                readOnly: true, // Make it read-only
                decoration: InputDecoration(labelText: 'Arrival Time'),
                controller: TextEditingController(
                    text: entry['arrivalTime']), // Display selected time
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

  // Add new timetable row
  void _addTimetableRow() {
    setState(() {
      _timetable.add({
        'departureTime': '',
        'arrivalTime': '',
      });
    });
  }

  // Format time to 24-hour format
  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formattedTime =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return formattedTime;
  }
}
