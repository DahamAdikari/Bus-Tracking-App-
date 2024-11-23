import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/pages/Driver/MapSelection.dart';
import 'package:uuid/uuid.dart'; // Add uuid package for unique ID generation

import './otherway.dart';

// class RegistrationPageClass extends StatefulWidget {
//   final String userID;

//   RegistrationPageClass({required this.userID});

//   @override
//   RegistrationPage createState() => RegistrationPage();
// }

// class RegistrationPage extends State<RegistrationPageClass> {
//   final _formKey = GlobalKey<FormState>();
//   final Uuid uuid = Uuid();
//   String busID = ""; // Auto-generated Bus ID
//   List<Map<String, String>> _timetable = [
//     {'departureTime': '', 'arrivalTime': ''}
//   ]; // Default timetable

//   String? busName;
//   String? routeNum;
//   String? numberPlate;
//   LatLng? sourceLocationLatLng;
//   LatLng? destinationLocationLatLng;
//   String? sourceLocation;
//   String? destinationLocation;

//   late String userID;

//   @override
//   void initState() {
//     super.initState();
//     userID = widget.userID;

//     // Auto-generate a unique Bus ID
//     busID = uuid.v4(); // Generate unique ID using UUID
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Bus Details'),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Form(
//             key: _formKey,
//             child: Column(
//               children: [
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Bus ID'),
//                   initialValue: busID,
//                   readOnly: true, // Make this field read-only
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Bus Name'),
//                   onSaved: (value) {
//                     busName = value;
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the bus name';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Route Number'),
//                   onSaved: (value) {
//                     routeNum = value;
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the route number';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Number Plate'),
//                   onSaved: (value) {
//                     numberPlate = value;
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the number plate';
//                     }
//                     return null;
//                   },
//                 ),
//                 TextFormField(
//                   decoration: InputDecoration(labelText: 'Source Location'),
//                   onSaved: (value) {
//                     sourceLocation = value;
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the source location';
//                     }
//                     return null;
//                   },
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final LatLng? result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             GoogleMapPage(), // Page for selecting source location
//                       ),
//                     );

//                     if (result != null) {
//                       setState(() {
//                         sourceLocationLatLng = result;
//                       });
//                     }
//                   },
//                   child: Text('Select Source Location'),
//                 ),
//                 if (sourceLocationLatLng != null)
//                   Text(
//                       'Source: ${sourceLocationLatLng!.latitude}, ${sourceLocationLatLng!.longitude}'),
//                 TextFormField(
//                   decoration:
//                       InputDecoration(labelText: 'Destination Location'),
//                   onSaved: (value) {
//                     destinationLocation = value;
//                   },
//                   validator: (value) {
//                     if (value == null || value.isEmpty) {
//                       return 'Please enter the destination location';
//                     }
//                     return null;
//                   },
//                 ),
//                 ElevatedButton(
//                   onPressed: () async {
//                     final LatLng? result = await Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                         builder: (context) =>
//                             GoogleMapPage(), // Page for selecting destination location
//                       ),
//                     );

//                     if (result != null) {
//                       setState(() {
//                         destinationLocationLatLng = result;
//                       });
//                     }
//                   },
//                   child: Text('Select Destination Location'),
//                 ),
//                 if (destinationLocationLatLng != null)
//                   Text(
//                       'Destination: ${destinationLocationLatLng!.latitude}, ${destinationLocationLatLng!.longitude}'),
//                 SizedBox(height: 20),
//                 Text('Timetable',
//                     style: TextStyle(fontWeight: FontWeight.bold)),
//                 _buildTimetable(),
//                 SizedBox(height: 10),
//                 ElevatedButton(
//                   onPressed: _addTimetableRow,
//                   child: Text('Add Timetable Row'),
//                 ),
//                 SizedBox(height: 20),
//                 ElevatedButton(
//                   onPressed: () {
//                     if (_formKey.currentState!.validate() &&
//                         sourceLocationLatLng != null &&
//                         destinationLocationLatLng != null) {
//                       _formKey.currentState!.save();

//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AddBusPage(
//                             userID: userID,
//                             busID: busID,
//                             busName: busName!,
//                             routeNum: routeNum!,
//                             sourceLocationLatLng: sourceLocationLatLng!,
//                             destinationLocationLatLng:
//                                 destinationLocationLatLng!,
//                             numberPlate: numberPlate!,
//                             sourceLocation: sourceLocation!,
//                             destinationLocation: destinationLocation!,
//                             timetable_org: _timetable,
//                           ),
//                         ),
//                       );
//                     } else {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(
//                             content: Text(
//                                 'Please select source and destination locations')),
//                       );
//                     }
//                   },
//                   child: Text('Next'),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildTimetable() {
//     return Column(
//       children: _timetable.map((entry) {
//         int index = _timetable.indexOf(entry);
//         return Row(
//           children: [
//             Expanded(
//               child: TextFormField(
//                 readOnly: true,
//                 decoration: InputDecoration(labelText: 'Departure Time'),
//                 controller: TextEditingController(text: entry['departureTime']),
//                 onTap: () async {
//                   TimeOfDay? pickedTime = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (pickedTime != null) {
//                     setState(() {
//                       _timetable[index]['departureTime'] =
//                           _formatTime(pickedTime);
//                     });
//                   }
//                 },
//               ),
//             ),
//             SizedBox(width: 10),
//             Expanded(
//               child: TextFormField(
//                 readOnly: true,
//                 decoration: InputDecoration(labelText: 'Arrival Time'),
//                 controller: TextEditingController(text: entry['arrivalTime']),
//                 onTap: () async {
//                   TimeOfDay? pickedTime = await showTimePicker(
//                     context: context,
//                     initialTime: TimeOfDay.now(),
//                   );
//                   if (pickedTime != null) {
//                     setState(() {
//                       _timetable[index]['arrivalTime'] =
//                           _formatTime(pickedTime);
//                     });
//                   }
//                 },
//               ),
//             ),
//             IconButton(
//               icon: Icon(Icons.delete),
//               onPressed: () {
//                 setState(() {
//                   _timetable.removeAt(index);
//                 });
//               },
//             ),
//           ],
//         );
//       }).toList(),
//     );
//   }

//   void _addTimetableRow() {
//     setState(() {
//       _timetable.add({
//         'departureTime': '',
//         'arrivalTime': '',
//       });
//     });
//   }

//   String _formatTime(TimeOfDay time) {
//     final now = DateTime.now();
//     final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
//     final formattedTime =
//         '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
//     return formattedTime;
//   }
// }

class RegistrationPageClass extends StatefulWidget {
  final String userID;

  RegistrationPageClass({required this.userID});

  @override
  RegistrationPage createState() => RegistrationPage();
}

class RegistrationPage extends State<RegistrationPageClass> {
  final _formKey = GlobalKey<FormState>();
  final Uuid uuid = Uuid();
  String busID = ""; // Auto-generated Bus ID
  List<Map<String, String>> _timetable = [
    {'departureTime': '', 'arrivalTime': ''}
  ]; // Default timetable

  String? busName;
  String? routeNum;
  String? numberPlate;
  String? contactNumber;
  LatLng? sourceLocationLatLng;
  LatLng? destinationLocationLatLng;
  String? sourceLocation;
  String? destinationLocation;

  late String userID;

  @override
  void initState() {
    super.initState();
    userID = widget.userID;

    // Auto-generate a unique Bus ID
    busID = uuid.v4(); // Generate unique ID using UUID
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF000080),
        title: Text('Add Bus Details',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildReadOnlyField('Bus ID', busID),
                SizedBox(height: 10),
                _buildTextField('Bus Name', 'Please enter the bus name',
                    (value) {
                  busName = value;
                }),
                SizedBox(height: 10),
                _buildTextField('Route Number', 'Please enter the route number',
                    (value) {
                  routeNum = value;
                }),
                SizedBox(height: 10),
                _buildTextField('Number Plate', 'Please enter the number plate',
                    (value) {
                  numberPlate = value;
                }),
                SizedBox(height: 10),
                _buildTextField(
                  'Contact Number',
                  'Please enter the contact number',
                  (value) {
                    contactNumber = value;
                  },
                ),
                SizedBox(height: 10),
                _buildTextField(
                    'Source Location', 'Please enter the source location',
                    (value) {
                  sourceLocation = value;
                }),
                SizedBox(height: 20),
                _buildLocationSelectionButton(
                  'Select Source Location',
                  sourceLocationLatLng,
                  () async {
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
                ),
                if (sourceLocationLatLng != null)
                  Text(
                      'Source: ${sourceLocationLatLng!.latitude}, ${sourceLocationLatLng!.longitude}',
                      style: TextStyle(color: Colors.blueGrey)),
                SizedBox(height: 10),
                _buildTextField('Destination Location',
                    'Please enter the destination location', (value) {
                  destinationLocation = value;
                }),
                SizedBox(height: 10),
                _buildLocationSelectionButton(
                  'Select Destination Location',
                  destinationLocationLatLng,
                  () async {
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
                ),
                if (destinationLocationLatLng != null)
                  Text(
                      'Destination: ${destinationLocationLatLng!.latitude}, ${destinationLocationLatLng!.longitude}',
                      style: TextStyle(color: Colors.blueGrey)),
                SizedBox(height: 20),
                Text('Timetable',
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                _buildTimetable(),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: _addTimetableRow,
                  style:
                      ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  child: Text('Add Timetable Row', 
                    style: TextStyle(
                      color: Colors.white,
                  ),
                  ),
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
                            busID: busID,
                            busName: busName!,
                            routeNum: routeNum!,
                            sourceLocationLatLng: sourceLocationLatLng!,
                            destinationLocationLatLng:
                                destinationLocationLatLng!,
                            numberPlate: numberPlate!,
                            contactNumber: contactNumber!,
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
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF000080)),
                  child: Text(
                    'Next',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, String errorMessage, Function(String?) onSaved) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.blue[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.blueAccent),
        ),
      ),
      onSaved: onSaved,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return errorMessage;
        }
        return null;
      },
    );
  }

  Widget _buildReadOnlyField(String label, String value) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.grey[200],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
      initialValue: value,
      readOnly: true,
    );
  }

  Widget _buildLocationSelectionButton(
      String label, LatLng? location, Function onPressed) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF000080),
        padding: EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      child: Text(label, style: TextStyle(fontSize: 16, color: Colors.white,)),
    );
  }

  Widget _buildTimetable() {
    return Column(
      children: _timetable.map((entry) {
        int index = _timetable.indexOf(entry);
        return Row(
          children: [
            Expanded(
              child: _buildTimePickerField('Departure Time',
                  entry['departureTime'], index, 'departureTime'),
            ),
            SizedBox(width: 10),
            Expanded(
              child: _buildTimePickerField(
                  'Arrival Time', entry['arrivalTime'], index, 'arrivalTime'),
            ),
            IconButton(
              icon: Icon(Icons.delete, color: Colors.red),
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

  Widget _buildTimePickerField(
      String label, String? time, int index, String timeKey) {
    return TextFormField(
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.blue[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
      controller: TextEditingController(text: time),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          setState(() {
            _timetable[index][timeKey] = _formatTime(pickedTime);
          });
        }
      },
    );
  }

  String _formatTime(TimeOfDay time) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    final formattedTime =
        '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return formattedTime;
  }

  void _addTimetableRow() {
    setState(() {
      _timetable.add({
        'departureTime': '',
        'arrivalTime': '',
      });
    });
  }
}
