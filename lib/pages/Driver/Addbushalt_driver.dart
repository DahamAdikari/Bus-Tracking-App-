import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_4/pages/selectLocationAdmin.dart'; // Adjust import as needed

class AddBusHaltPageDriver extends StatefulWidget {
  final String busId;
  final int? haltIndex;

  AddBusHaltPageDriver({required this.busId, this.haltIndex});

  @override
  _AddBusHaltPageDriverState createState() => _AddBusHaltPageDriverState();
}

class _AddBusHaltPageDriverState extends State<AddBusHaltPageDriver> {
  final _formKey = GlobalKey<FormState>();
  String? haltName;
  LatLng? _selectedLocation;
  String? _locationName;

  @override
  void initState() {
    super.initState();
    if (widget.haltIndex != null) {
      _loadHaltData();
    }
  }

  Future<void> _loadHaltData() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('buses')
        .doc(widget.busId)
        .get();

    List<dynamic> busHalts = doc['busHalts'];

    if (widget.haltIndex != null && widget.haltIndex! < busHalts.length) {
      Map<String, dynamic> halt = busHalts[widget.haltIndex!];
      setState(() {
        haltName = halt['name'];
        _selectedLocation = LatLng(halt['latitude'], halt['longitude']);
        _locationName = 'Location selected on map'; // Optional: Customize this
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:
            Text(widget.haltIndex == null ? 'Add Bus Halt' : 'Edit Bus Halt'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  initialValue: haltName,
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
                  child: Text('Select the location on the map'),
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
                  child: Text(widget.haltIndex == null
                      ? 'Add Bus Halt'
                      : 'Save Changes'),
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
        _locationName = 'Location selected on map';
      });
    }
  }

  void _submitHalt() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      if (_selectedLocation != null) {
        if (widget.haltIndex == null) {
          _addBusHalt();
        } else {
          _updateBusHalt();
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please select the bus halt location on the map'),
          ),
        );
      }
    }
  }

  Future<void> _addBusHalt() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('buses')
        .doc(widget.busId)
        .get();

    List<dynamic> busHalts = doc['busHalts'];
    busHalts.add({
      'name': haltName,
      'latitude': _selectedLocation!.latitude,
      'longitude': _selectedLocation!.longitude,
    });

    await FirebaseFirestore.instance
        .collection('buses')
        .doc(widget.busId)
        .update({
      'busHalts': busHalts,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bus halt added successfully!')),
    );

    Navigator.pop(context);
  }

  Future<void> _updateBusHalt() async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('buses')
        .doc(widget.busId)
        .get();

    List<dynamic> busHalts = doc['busHalts'];
    busHalts[widget.haltIndex!] = {
      'name': haltName,
      'latitude': _selectedLocation!.latitude,
      'longitude': _selectedLocation!.longitude,
    };

    await FirebaseFirestore.instance
        .collection('buses')
        .doc(widget.busId)
        .update({
      'busHalts': busHalts,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bus halt updated successfully!')),
    );

    Navigator.pop(context);
  }
}
