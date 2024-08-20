import 'package:flutter/material.dart';
import 'package:test_4/pages/passenger/buslist_passenger.dart';

class SearchBusPage extends StatefulWidget {
  @override
  _SearchBusPageState createState() => _SearchBusPageState();
}

class _SearchBusPageState extends State<SearchBusPage> {
  final _formKey = GlobalKey<FormState>();
  String? sourceLocation;
  String? destinationLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Buses'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Source Location'),
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
              TextFormField(
                decoration: InputDecoration(labelText: 'Destination Location'),
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
                child: Text('View Buses'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
