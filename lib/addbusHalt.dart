import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/pages/selectLocationAdmin.dart';

class AddBusHaltPage extends StatefulWidget {
  @override
  _AddBusHaltPageState createState() => _AddBusHaltPageState();
}

class _AddBusHaltPageState extends State<AddBusHaltPage> {
  final _formKey = GlobalKey<FormState>();
  String? haltName;
  LatLng? _selectedLocation;
  String? _locationName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Bus Halt'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Bus Halt Name'),
                  onSaved: (value) {
                    haltName = value;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid bus halt name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _selectLocation,
                  child: Text('Select the location in the map'),
                ),
                if (_locationName != null) ...[
                  SizedBox(height: 20),
                  Text('Selected Location:'),
                  Text('$_locationName'),
                  Text('Latitude: ${_selectedLocation?.latitude}'),
                  Text('Longitude: ${_selectedLocation?.longitude}'),
                ],
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitHalt,
                  child: Text('Add Bus Halt'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _selectLocation() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SelectLocationPage(),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result['location'];
        _locationName =
            'Location selected on map'; // Optional: Customize this based on your needs
      });
    }
  }

  void _submitHalt() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedLocation != null) {
        Navigator.pop(context, {
          'name': haltName,
          'location': _selectedLocation,
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Please select the bus halt location on the map')),
        );
      }
    }
  }
}
