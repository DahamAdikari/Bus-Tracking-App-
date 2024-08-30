import 'package:flutter/material.dart';

class RegSeats extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Seats'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(
                context); // Navigate back to the RegistrationPageClass
          },
          child: Text('Confirm seats order'),
        ),
      ),
    );
  }
}
