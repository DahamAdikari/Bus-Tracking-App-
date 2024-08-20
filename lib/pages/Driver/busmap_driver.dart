import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BusLocationMapPage extends StatefulWidget {
  final String busId;

  BusLocationMapPage({required this.busId});

  @override
  _BusLocationMapPageState createState() => _BusLocationMapPageState();
}

class _BusLocationMapPageState extends State<BusLocationMapPage> {
  GoogleMapController? _mapController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Location'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('buses')
            .doc(widget.busId)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var busData = snapshot.data!;
          double latitude = busData['latitude'] ?? 0.0;
          double longitude = busData['longitude'] ?? 0.0;

          LatLng busLocation = LatLng(latitude, longitude);

          // Update camera position when location changes
          if (_mapController != null) {
            _mapController!.animateCamera(CameraUpdate.newLatLng(busLocation));
          }

          return GoogleMap(
            initialCameraPosition: CameraPosition(
              target: busLocation,
              zoom: 14,
            ),
            markers: {
              Marker(
                markerId: MarkerId('busLocation'),
                position: busLocation,
              ),
            },
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              // Move the camera to the initial bus location
              _mapController!
                  .animateCamera(CameraUpdate.newLatLng(busLocation));
            },
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
