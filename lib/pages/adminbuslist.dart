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
            return ListView(
              children: snapshot.data!.docs.map((doc) {
                Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;
                return ListTile(
                  title: Text(data['busName'] ?? 'No Name'),
                  subtitle: Text(data['sourceLocation'] +
                          ' - ' +
                          data['destinationLocation'] ??
                      'No Locations'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminPage(
                          data: data, // Pass the document data to AdminPage
                        ),
                      ),
                    );
                  },
                );
              }).toList(),
            );
          }
        },
      ),
    );
  }
}
