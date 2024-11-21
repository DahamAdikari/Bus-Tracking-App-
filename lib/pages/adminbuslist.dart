import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_4/pages/admin.dart';

class RegistrationListPage extends StatefulWidget {
  @override
  _RegistrationListPageState createState() => _RegistrationListPageState();
}

class _RegistrationListPageState extends State<RegistrationListPage> {
  final CollectionReference _registrationCollection =
      FirebaseFirestore.instance.collection('registration');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Registration List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _registrationCollection.snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(child: Text('No registrations found.'));
          } else {
            // Convert QuerySnapshot to a List of Documents
            List<QueryDocumentSnapshot> docs = snapshot.data!.docs;

            // Sort the documents based on createdAt field
            docs.sort((a, b) {
              Timestamp? createdAtA = a['createdAt'];
              Timestamp? createdAtB = b['createdAt'];

              // If createdAt is null, we push it to the end
              if (createdAtA == null && createdAtB != null) {
                return 1; // a comes after b
              } else if (createdAtA != null && createdAtB == null) {
                return -1; // a comes before b
              } else if (createdAtA == null && createdAtB == null) {
                return 0; // both are null, so they are equal
              } else {
                // If both have createdAt, compare them
                return createdAtA!.compareTo(createdAtB!);
              }
            });

            return ListView(
              children: docs.map((doc) {
                Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                bool isAdded = data['isadd'] == true;

                // Set color based on the isadd field
                Color cardColor = isAdded ? Colors.blue.shade200 : Colors.red;
                String statusText = isAdded ? 'Added' : 'Not Added';

                return Card(
                  color: cardColor, // Use the color here
                  child: ListTile(
                    title: Text(data['busName'] ?? 'No Name'),
                    subtitle: Text(
                      '${data['sourceLocation']} - ${data['destinationLocation']}' ??
                          'No Locations',
                    ),
                    trailing: Text(statusText,
                        style: TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white)),
                    onTap: () {
                      // Pass the doc ID to AdminPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AdminPage(
                            docID: doc.id, // Pass the document ID
                          ),
                        ),
                      );
                    },
                  ),
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
