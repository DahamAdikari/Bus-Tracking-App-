import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectCurrentLocationPage extends StatefulWidget {
  @override
  _SelectCurrentLocationPageState createState() =>
      _SelectCurrentLocationPageState();
}

class _SelectCurrentLocationPageState extends State<SelectCurrentLocationPage> {
  LatLng? _selectedLocation;
  GoogleMapController? _mapController;

  void _onMapTap(LatLng location) {
    setState(() {
      _selectedLocation = location;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Current Location'),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onTap: _onMapTap,
            onMapCreated: (controller) {
              _mapController = controller;
            },
            markers: _selectedLocation != null
                ? {
                    Marker(
                      markerId: MarkerId('selected-location'),
                      position: _selectedLocation!,
                    ),
                  }
                : {},
            initialCameraPosition: CameraPosition(
              target: LatLng(7.8731, 80.7718), // Default location (Sri Lanka)
              zoom: 7.0,
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 16.0,
            right: 16.0,
            child: ElevatedButton(
              onPressed: _selectedLocation != null
                  ? () {
                      Navigator.pop(context, _selectedLocation);
                    }
                  : null,
              child: Text('Confirm Location'),
            ),
          ),
        ],
      ),
    );
  }
}
