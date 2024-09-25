import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class BusFullMapPage extends StatefulWidget {
  final String busId;
  final String driverId;

  BusFullMapPage({required this.busId, required this.driverId});

  @override
  _BusFullMapPageState createState() => _BusFullMapPageState();
}

class _BusFullMapPageState extends State<BusFullMapPage> {
  GoogleMapController? _mapController;

  Stream<DocumentSnapshot>? _busStream;

  @override
  void initState() {
    super.initState();
    _busStream = _getBusStream();
  }

  Stream<DocumentSnapshot> _getBusStream() {
    // Return a stream of the bus document from the specific driver's subcollection
    return FirebaseFirestore.instance
        .collection('driver')
        .doc(widget.driverId)
        .collection('buses')
        .doc(widget.busId)
        .snapshots();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _moveCamera(LatLng position) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Full Map View'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _busStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var busData = snapshot.data!;
          double latitude = busData['latitude']?.toDouble() ?? 0.0;
          double longitude = busData['longitude']?.toDouble() ?? 0.0;

          LatLng busLocation = LatLng(latitude, longitude);

          WidgetsBinding.instance.addPostFrameCallback((_) {
            _moveCamera(busLocation);
          });

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
            onMapCreated: _onMapCreated,
          );
        },
      ),
    );
  }
}
