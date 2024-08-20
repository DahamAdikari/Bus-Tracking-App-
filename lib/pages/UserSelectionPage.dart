import 'package:flutter/material.dart';
import 'package:test_4/pages/admin.dart';
import 'package:test_4/pages/Driver/buslist_driver.dart';
//import 'package:test_4/pages/map_page.dart';
//import 'package:test_4/pages/Driver/map_page_driver.dart';

import 'package:test_4/pages/passenger/searchpage_passenger.dart';

class UserSelectionPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select User Type'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                // Navigate to the passenger's map page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchBusPage()),
                );
              },
              child: Text('I am a Passenger'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the driver's map page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => BusListPageDriver()),
                );
              },
              child: Text('I am a Driver'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Navigate to the passenger's map page
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AdminPage()),
                );
              },
              child: Text('Admin'),
            ),
          ],
        ),
      ),
    );
  }
}
