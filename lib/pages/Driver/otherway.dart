import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/addbusHalt.dart';
import 'package:test_4/pages/SelectCurrentAdmin.dart';
import 'package:intl/intl.dart';
import './Reg_seats.dart';

class AddBusPage extends StatefulWidget {
  final String userID;
  final String busID;
  final String busName;
  final String routeNum;
  final String sourceLocation;
  final String destinationLocation;
  final List<Map<String, String>> timetable_org;

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
  bool hasReturnTrip = false;
  List<Map<String, dynamic>> _timetable = [];
  Map<String, dynamic>? _seatData;

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
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RegSeats(),
                    ),
                  );

                  if (result != null) {
                    setState(() {
                      _seatData = result;
                    });
                  }
                },
                child: Text('Add Seats'),
              ),
              if (_selectedLocation != null)
                Text(
                    'Selected Location: Lat: ${_selectedLocation!.latitude}, Lng: ${_selectedLocation!.longitude}'),
              if (_seatData != null)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Selected Seat Model: ${_seatData!['selectedModel']}'),
                    Text('Total Seats: ${_seatData!['seatCount']}'),
                    Text('Total Rows: ${_seatData!['rows']}'),
                  ],
                ),
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

  String _formatTimeOfDay(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final format = DateFormat('HH:mm');
    return format.format(dt);
  }

  void _addTimetableRow() {
    setState(() {
      _timetable.add({
        'departureTime': '',
        'arrivalTime': '',
      });
    });
  }

  List<Map<String, dynamic>> flattenSeatLayout(
      List<List<Map<String, dynamic>>> seatLayout) {
    List<Map<String, dynamic>> flatList = [];

    for (int row = 0; row < seatLayout.length; row++) {
      for (int col = 0; col < seatLayout[row].length; col++) {
        Map<String, dynamic> seat = seatLayout[row][col];
        flatList.add({
          'row': row,
          'col': col,
          'status': seat['status'],
        });
      }
    }
    return flatList;
  }

  void _submitBus() {

    if (_seatData == null || _seatData?['seatLayout'] == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Please add seat data before submitting the bus.')),
    );}

    List<Map<String, dynamic>>? flatSeatLayout =
        flattenSeatLayout(_seatData?['seatLayout']);

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
      'hasReturnTrip': hasReturnTrip,
      'timetable': hasReturnTrip ? _timetable : [],
      'seatData': {
        'selectedModel': _seatData?['selectedModel'],
        'rows': _seatData?['rows'],
        'seatCount': _seatData?['seatCount'],
        'seatLayout': flatSeatLayout, // Store the flattened seat layout
      },
      'isOnline': false,
      'bookingAvailable': false,
      'createdAt': FieldValue.serverTimestamp(),
    }).then((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bus added successfully')),
      );
      Navigator.pop(context);
    }).catchError((error) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to add bus: $error')));
    });
  }
}
