import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_4/pages/Driver/busdetails_driver.dart';
import 'package:test_4/pages/Driver/registration_form.dart';

class BusListPageDriver extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user's UID
    final user = FirebaseAuth.instance.currentUser;
    final String? userID = user?.uid;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select Your Bus'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                if (userID != null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          RegistrationPageClass(userID: userID), // Pass the UID
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('User not logged in!')),
                  );
                }
              },
              child: Text('Go to Registration Page'),
            ),
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('buses').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }
                var buses = snapshot.data!.docs;
                return ListView.builder(
                  itemCount: buses.length,
                  itemBuilder: (context, index) {
                    var bus = buses[index];
                    return ListTile(
                      title: Text(bus['busName']),
                      subtitle: Text(bus['routeNum']),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusDetailsPage(busId: bus.id),
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
