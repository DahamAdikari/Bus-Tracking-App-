import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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
          style: const TextStyle(fontSize: 25.0),
        ),
        backgroundColor: Colors.lightBlue,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(height: 10),
              Text(
                "Search for the bus you need!",
                style: const TextStyle(fontSize: 20),
              ),
              Center(
                child: Image.asset(
                  'assets/images/search_bus.png',
                  height: 200, // Adjust the height to prevent overflow
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),

              // Source Location TextFormField with autocomplete dropdown
              TextFormField(
                controller: sourceController, // Connect controller
                decoration: InputDecoration(labelText: 'Source Location'),
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

              // Destination Location TextFormField with autocomplete dropdown
              TextFormField(
                controller: destinationController, // Connect controller
                decoration: InputDecoration(labelText: 'Destination Location'),
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

              SizedBox(height: 20),
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
                  backgroundColor: const Color(0xFF03A9F4),
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
