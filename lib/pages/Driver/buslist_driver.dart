import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_4/pages/Driver/busdetails_driver.dart';
import 'package:test_4/pages/Driver/registration_form.dart';

class BusListPageDriver extends StatefulWidget {
  @override
  _BusListPageDriverState createState() => _BusListPageDriverState();
}

class _BusListPageDriverState extends State<BusListPageDriver> {
  @override
  Widget build(BuildContext context) {
    // Get the current user's UID
    final user = FirebaseAuth.instance.currentUser;
    final String? userID = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Bus'),
        backgroundColor: Colors.lightBlue, // Set app bar color to light blue
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {}); // Rebuild the widget to fetch updated data
            },
          ),
        ],
      ),
      body: Container(
        color: Colors.lightBlue[50], // Set a light blue background for the page
        child: Column(
          children: [
            // The list of buses should appear first
            Expanded(
              child: userID == null
                  ? Center(child: Text('User not logged in!'))
                  : StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          //TEMPORARLILY fetch from the registration Collection
                          .collection(
                              'registration') //Delete this line and un-comment below lines

                          //Original code for fetching from the original location
                          // .collection(
                          //     'driver')
                          //      // Assuming 'driver' is your top-level collection
                          // .doc(
                          //     userID) // Use the userID to reference the specific user document
                          // .collection(
                          //     'buses') // Access the 'buses' sub-collection
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(child: CircularProgressIndicator());
                        }
                        var buses = snapshot.data!.docs;
                        if (buses.isEmpty) {
                          return Center(child: Text('No buses found.'));
                        }
                        return ListView.builder(
                          itemCount: buses.length,
                          itemBuilder: (context, index) {
                            var bus = buses[index];
                            return Container(
                              margin: EdgeInsets.symmetric(
                                  vertical: 4.0, horizontal: 8.0),
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Colors
                                      .blue, // Blue border around the list element
                                  width: 1.0,
                                ),
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: ListTile(
                                title: Text(bus['busName']),
                                subtitle: Text(
                                    '${bus['sourceLocation']} -> ${bus['destinationLocation']}'),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          BusDetailsPage(busId: bus.id),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
            // "Add a Bus" button should appear below the list
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue[800], // White text color
                ),
                onPressed: () {
                  if (userID != null) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegistrationPageClass(
                            userID: userID), // Pass the UID
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('User not logged in!')),
                    );
                  }
                },
                child: Text('Add a Bus'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
