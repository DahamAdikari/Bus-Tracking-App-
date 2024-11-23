import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/addbusHalt.dart';
import 'package:test_4/pages/Driver/MapSelection.dart';
import 'package:test_4/pages/SelectCurrentAdmin.dart';
import 'package:test_4/pages/Useless/SeatLayoutDriver.dart';
import 'package:test_4/pages/Useless/adminreturntrip.dart';
import 'package:test_4/pages/displaySeats.dart';
import 'package:test_4/pages/Useless/busruteAdmin.dart';

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
  List<dynamic>? _seatLayout; // Store seat layout
  int? _rows; // Store number of rows
  int? _seatCount; // Store seat count
  int? _selectedModel; // Store selected model
  bool? bookingAvailable;
  String? numberPlate;
  LatLng? sourceLatLng; // Store source location LatLng
  LatLng? destinationLatLng; // Store destination location LatLng
  String? ticketPrice; // Store ticket price
  String? contactNumber;

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
          numberPlate = data['numberPlate']; // Fetch numberPlate
          ticketPrice = data['ticketPrice']; // Fetch ticketPrice
          contactNumber = data['contactNumber'];

          // Source and Destination LatLng
          if (data['sourceLatLng'] != null) {
            sourceLatLng = LatLng(data['sourceLatLng']['latitude'],
                data['sourceLatLng']['longitude']);
          }
          if (data['destinationLatLng'] != null) {
            destinationLatLng = LatLng(data['destinationLatLng']['latitude'],
                data['destinationLatLng']['longitude']);
          }
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
          bookingAvailable = data['bookingAvailable'];
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
        backgroundColor: Colors.blue,
        title: Text('Add Bus Details',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
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
                        child: Text(
                          'Edit Source Location',
                          style: TextStyle(
                            fontSize: 16, // Font size
                            fontWeight: FontWeight.bold, // Font weight
                            color: Colors.blue.shade900, // Text color
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 40),
                        ),
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
                        child: Text(
                          'Edit Destination Location',
                          style: TextStyle(
                            fontSize: 16, // Font size
                            fontWeight: FontWeight.bold, // Font weight
                            color: Colors.blue.shade900, // Text color
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 40),
                        ),
                      ),

                      if (destinationLatLng != null)
                        Text(
                            'Destination Location: Lat: ${destinationLatLng!.latitude}, Lng: ${destinationLatLng!.longitude}'),
                      _buildTextFormField('Number Plate', numberPlate,
                          (value) => numberPlate = value),

                      _buildTextFormField('Ticket Price', ticketPrice,
                          (value) => ticketPrice = value),

                      _buildTextFormField('Contact Number', contactNumber,
                          (value) => contactNumber = value,),

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
                        child: Text(
                          'Add Bus Halt',
                          style: TextStyle(
                            fontSize: 16, // Font size
                            fontWeight: FontWeight.bold, // Font weight
                            color: Colors.blue.shade900, // Text color
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 40),
                        ),
                      ),

                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdminRouteCreationPage(
                                busId: '',
                              ),
                            ),
                          );
                        },
                        child: Text(
                          'Create Route',
                          style: TextStyle(
                            fontSize: 16, // Font size
                            fontWeight: FontWeight.bold, // Font weight
                            color: Colors.blue.shade900, // Text color
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 40),
                        ),
                      ),

                      // Add Seats button
                      ElevatedButton(
                        onPressed: () async {
                          if (widget.docID != null) {
                            // Navigate to DisplaySeats and await result
                            final result = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DisplaySeats(
                                    docID: widget
                                        .docID!), // Pass docID to DisplaySeats
                              ),
                            );

                            if (result != null) {
                              setState(() {
                                _seatLayout =
                                    result['seatLayout']; // Get seat layout
                                _rows = result['rows']; // Get number of rows
                                _seatCount =
                                    result['seatCount']; // Get seat count
                                _selectedModel = result[
                                    'selectedModel']; // Get selected model
                              });
                            }
                          } else {
                            // Show an error message if the docID is null
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                  content: Text(
                                      'Document ID is not available. Cannot proceed to add seats.')),
                            );
                          }
                        },
                        child: Text(
                          'Add Seats',
                          style: TextStyle(
                            fontSize: 16, // Font size
                            fontWeight: FontWeight.bold, // Font weight
                            color: Colors.blue.shade900, // Text color
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 40),
                        ),
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
                          } else {
                            // Handle the case where the user didn't select a location
                            // For example, you could show an error message or prevent further actions
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Please select a location.'),
                              ),
                            );
                          }
                        },
                        child: Text(
                          'Add Current Location of the Bus',
                          style: TextStyle(
                            fontSize: 16, // Font size
                            fontWeight: FontWeight.bold, // Font weight
                            color: Colors.blue.shade900, // Text color
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 40),
                        ),
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
                        child: Text(
                          'Add Bus',
                            style: TextStyle(
                              fontSize: 16, // Font size
                              fontWeight: FontWeight.bold, // Font weight
                              color: Colors.white, // Text color
                            ),
                          ),
                        style: ElevatedButton.styleFrom(
                          fixedSize: Size(300, 40),
                          backgroundColor: Colors.blue.shade900,
                        ),
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
        //child: Text('Add the return bus'),
        child: Text(
          'Add the return bus',
            style: TextStyle(
            fontSize: 16, // Font size
            fontWeight: FontWeight.bold, // Font weight
            color: Colors.white, // Text color
            ),
        ),
        style: ElevatedButton.styleFrom(
        fixedSize: Size(300, 40),
        backgroundColor: Colors.blue,
        ),
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

  // Submit form data to Firestore
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
        'numberPlate': numberPlate, // Include numberPlate
        'ticketPrice': ticketPrice, // Include ticketPrice
        'contactNumber': contactNumber, 
        'latitude': _selectedLocation?.latitude,
        'longitude': _selectedLocation?.longitude,
        'busHalts': _busHalts,
        'isOnline': false,
        'timetableorg': _timetableorg,
        'hasReturnTrip': _hasReturnTrip,
        'onWay': false,
        'timetable': null,
        'sourceLatLng': {
          'latitude': sourceLatLng?.latitude,
          'longitude': sourceLatLng?.longitude,
        }, // Include sourceLatLng
        'destinationLatLng': {
          'latitude': destinationLatLng?.latitude,
          'longitude': destinationLatLng?.longitude,
        }, // Include destinationLatLng
        'seatData': {
          'seatLayout': _seatLayout,
          'rows': _rows,
          'seatCount': _seatCount,
          'selectedModel': _selectedModel,
        },
        'bookingAvailable': bookingAvailable,
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
          _seatLayout = null;
          _rows = null;
          _seatCount = null;
          _selectedModel = null;
          bookingAvailable = null;
        });
      }).catchError((error) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to add bus: $error')),
        );
      });
    }
  }
}
