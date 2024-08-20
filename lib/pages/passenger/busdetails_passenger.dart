import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/pages/passenger/busmap_passenger.dart';

class BusDetailsPagePassenger extends StatefulWidget {
  final String busId;

  BusDetailsPagePassenger({required this.busId});

  @override
  _BusDetailsPagePassengerState createState() =>
      _BusDetailsPagePassengerState();
}

class _BusDetailsPagePassengerState extends State<BusDetailsPagePassenger> {
  GoogleMapController? _mapController;

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
        title: Text('Bus Details'),
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
          LatLng busPosition = LatLng(
            busData['latitude'] ?? 0.0,
            busData['longitude'] ?? 0.0,
          );

          // Move the camera to the bus's current position
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _moveCamera(busPosition);
          });

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bus Name: ${busData['busName']}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Route Number: ${busData['routeNum']}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Source Location: ${busData['sourceLocation']}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Text('Destination Location: ${busData['destinationLocation']}',
                    style: TextStyle(fontSize: 18)),
                SizedBox(height: 20),
                Container(
                  height: 300,
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: busPosition,
                      zoom: 14,
                    ),
                    markers: {
                      Marker(
                        markerId: MarkerId('busLocation'),
                        position: busPosition,
                      ),
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            BusFullMapPage(busId: widget.busId),
                      ),
                    );
                  },
                  child: Text('View Full Map'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
