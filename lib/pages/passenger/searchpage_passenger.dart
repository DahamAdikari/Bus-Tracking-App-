import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_4/auth/constants/colors.dart';
import 'package:test_4/pages/passenger/buslist_passenger.dart';

class SearchBusPage extends StatefulWidget {
  @override
  _SearchBusPageState createState() => _SearchBusPageState();
}

class _SearchBusPageState extends State<SearchBusPage> {
  final _formKey = GlobalKey<FormState>();
  String? sourceLocation;
  String? destinationLocation;

  // Create controllers for source and destination TextFormField
  TextEditingController sourceController = TextEditingController();
  TextEditingController destinationController = TextEditingController();

  List<String> sourceSuggestions = [];
  List<String> destinationSuggestions = [];

  // Fetch source and destination locations from Firestore
  Future<void> fetchLocations(String searchText, bool isSource) async {
    Set<String> suggestions = {};

    // Query Firestore
    final querySnapshot =
        await FirebaseFirestore.instance.collection('driver').get();

    for (var driverDoc in querySnapshot.docs) {
      final busesSnapshot = await driverDoc.reference.collection('buses').get();

      for (var busDoc in busesSnapshot.docs) {
        String fetchedLocation;
        if (isSource) {
          fetchedLocation = busDoc['sourceLocation'];
        } else {
          fetchedLocation = busDoc['destinationLocation'];
        }

        if (fetchedLocation
            .toLowerCase()
            .startsWith(searchText.toLowerCase())) {
          suggestions.add(fetchedLocation);
        }
      }
    }

    // Update state with fetched suggestions
    setState(() {
      if (isSource) {
        sourceSuggestions = suggestions.toList();
      } else {
        destinationSuggestions = suggestions.toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Search Buses',
          style: const TextStyle(fontSize: 25.0,color:Colors.white),
        ),
        backgroundColor:tPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 20),
              Text(
                "🚍 Search for the Bus you need!",
                style: const TextStyle(
                  fontSize: 22, // Slightly larger font size
                  fontWeight: FontWeight.bold, // Bold text for emphasis
                  color:tPrimaryColor, // Attractive color for better visibility
                ),
                textAlign: TextAlign.center, // Center the text for a balanced look
              ),

              Center(
                child: Image.asset(
                  'assets/images/search_bus.png',
                  height: 250, // Adjust the height to prevent overflow
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),

              // Source Location TextFormField with autocomplete dropdown
              // TextFormField(
              //   controller: sourceController, // Connect controller
              //   decoration: InputDecoration(labelText: 'Source Location'),
              //   onChanged: (value) {
              //     if (value.isNotEmpty) {
              //       fetchLocations(value, true); // Fetch source locations
              //     }
              //   },
              //   onSaved: (value) {
              //     sourceLocation = value;
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a valid source location';
              //     }
              //     return null;
              //   },
              // ),

              TextFormField(
                controller: sourceController, // Connect controller
                decoration: InputDecoration(
                  labelText: 'Enter Source Location',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600], // Subtle label color for better readability
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: 'Search for a location...', // Add hint for better UX
                  hintStyle: TextStyle(
                    color: Colors.grey[400], // Subtle hint color
                  ),
                  prefixIcon: Icon(
                    Icons.location_on, // Location icon for better context
                    color: Colors.blueAccent, // Accent color for the icon
                  ),
                  filled: true, // Filled background for better focus
                  fillColor: Colors.grey[100], // Light background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded borders for a modern look
                    borderSide: BorderSide.none, // Remove default border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5), // Subtle border when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.blueAccent, width: 2), // Bold blue border on focus
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Comfortable padding
                ),
                style: TextStyle(fontSize: 16, color: Colors.black87), // Make text more readable
                cursorColor: Colors.blueAccent, // Color of the blinking cursor
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    fetchLocations(value, true); // Fetch source locations
                  }
                },
                onSaved: (value) {
                  sourceLocation = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid source location';
                  }
                  return null;
                },
              ),

              if (sourceSuggestions.isNotEmpty)
                Container(
                  height: 100,
                  child: ListView.builder(
                    itemCount: sourceSuggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(sourceSuggestions[index]),
                        onTap: () {
                          setState(() {
                            sourceController.text = sourceSuggestions[index];
                            sourceLocation = sourceSuggestions[
                                index]; // Set the selected value
                            sourceSuggestions = []; // Clear suggestions
                          });
                        },
                      );
                    },
                  ),
                ),
              SizedBox(height: 30,),
              // Destination Location TextFormField with autocomplete dropdown
              // TextFormField(
              //   controller: destinationController, // Connect controller
              //   decoration: InputDecoration(labelText: 'Destination Location'),
              //   onChanged: (value) {
              //     if (value.isNotEmpty) {
              //       fetchLocations(value, false); // Fetch destination locations
              //     }
              //   },
              //   onSaved: (value) {
              //     destinationLocation = value;
              //   },
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return 'Please enter a valid destination location';
              //     }
              //     return null;
              //   },
              // ),

              TextFormField(
                controller: destinationController, // Connect controller
                decoration: InputDecoration(
                  labelText: 'Enter Destination Location',
                  labelStyle: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600], // Subtle label color for better readability
                    fontWeight: FontWeight.w500,
                  ),
                  hintText: 'Search for a location...', // Add hint for better UX
                  hintStyle: TextStyle(
                    color: Colors.grey[400], // Subtle hint color
                  ),
                  prefixIcon: Icon(
                    Icons.location_on, // Location icon for better context
                    color: Colors.redAccent, // Accent color for the icon (different from source)
                  ),
                  filled: true, // Filled background for better focus
                  fillColor: Colors.grey[100], // Light background color
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded borders for a modern look
                    borderSide: BorderSide.none, // Remove default border
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5), // Subtle border when not focused
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.redAccent, width: 2), // Bold red border on focus (different from source)
                  ),
                  contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 20), // Comfortable padding
                ),
                style: TextStyle(fontSize: 16, color: Colors.black87), // Make text more readable
                cursorColor: Colors.redAccent, // Color of the blinking cursor (matches focused border)
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    fetchLocations(value, false); // Fetch destination locations
                  }
                },
                onSaved: (value) {
                  destinationLocation = value;
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a valid destination location';
                  }
                  return null;
                },
              ),
              if (destinationSuggestions.isNotEmpty)
                Container(
                  height: 100,
                  child: ListView.builder(
                    itemCount: destinationSuggestions.length,
                    itemBuilder: (context, index) {
                      return ListTile(
                        title: Text(destinationSuggestions[index]),
                        onTap: () {
                          setState(() {
                            destinationController.text =
                                destinationSuggestions[index];
                            destinationLocation = destinationSuggestions[
                                index]; // Set the selected value
                            destinationSuggestions = []; // Clear suggestions
                          });
                        },
                      );
                    },
                  ),
                ),
              SizedBox(height: 60),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusListPagePassenger(
                          source: sourceLocation!,
                          destination: destinationLocation!,
                        ),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: tPrimaryColor,
                ),
                child: Text('View Buses'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
