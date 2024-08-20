import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminPanel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Admin Panel')),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('drivers').where('approved', isEqualTo: false).snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var driver = snapshot.data!.docs[index];
              return ListTile(
                title: Text(driver['busOwner']),
                subtitle: Text(driver['busNumber']),
                trailing: ElevatedButton(
                  onPressed: () {
                    FirebaseFirestore.instance.collection('drivers').doc(driver.id).update({
                      'approved': true,
                    });
                  },
                  child: Text('Approve'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
