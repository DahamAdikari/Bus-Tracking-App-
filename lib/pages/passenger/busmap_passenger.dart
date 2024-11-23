import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/auth/constants/colors.dart';

// class BusFullMapPage extends StatefulWidget {
//   final String busId;
//   final String driverId;

//   BusFullMapPage({required this.busId, required this.driverId});

//   @override
//   _BusFullMapPageState createState() => _BusFullMapPageState();
// }

// class _BusFullMapPageState extends State<BusFullMapPage> {
//   GoogleMapController? _mapController;

//   Stream<DocumentSnapshot>? _busStream;

//   @override
//   void initState() {
//     super.initState();
//     _busStream = _getBusStream();
//   }

//   Stream<DocumentSnapshot> _getBusStream() {
//     // Return a stream of the bus document from the specific driver's subcollection
//     return FirebaseFirestore.instance
//         .collection('driver')
//         .doc(widget.driverId)
//         .collection('buses')
//         .doc(widget.busId)
//         .snapshots();
//   }

//   void _onMapCreated(GoogleMapController controller) {
//     _mapController = controller;
//   }

//   void _moveCamera(LatLng position) {
//     _mapController?.animateCamera(
//       CameraUpdate.newLatLng(position),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           'Bus Full Map View',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             color: tWhiteColor,
//           ),
//         ),
//         centerTitle: true,
//         backgroundColor: tPrimaryColor,
//         iconTheme: IconThemeData(color: Colors.white),
//         elevation: 4,
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: _busStream,
//         builder: (context, snapshot) {
//           if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           }
//           if (!snapshot.hasData) {
//             return Center(child: CircularProgressIndicator());
//           }

//           var busData = snapshot.data!;
//           double latitude = busData['latitude']?.toDouble() ?? 0.0;
//           double longitude = busData['longitude']?.toDouble() ?? 0.0;

//           //add source lat
//           //add source long

//           //add dest lat
//           //add dest lat

//           LatLng busLocation = LatLng(latitude, longitude);

//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             _moveCamera(busLocation);
//           });

//           return GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: busLocation,
//               zoom: 14,
//             ),
//             markers: {
//               Marker(
//                 markerId: MarkerId('busLocation'),
//                 position: busLocation,
//               ),
//             },
//             onMapCreated: _onMapCreated,
//           );
//         },
//       ),
//     );
//   }
// }
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

  LatLng? _sourceLocation; // Source location of the bus
  LatLng? _destinationLocation; // Destination location of the bus

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
        title: Text(
          'Bus Full Map View',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: tWhiteColor,
          ),
        ),
        centerTitle: true,
        backgroundColor: tPrimaryColor,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 4,
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

          // Retrieve source and destination coordinates
          double sourceLat =
              busData['sourceLatLng']['latitude']?.toDouble() ?? 0.0;
          double sourceLng =
              busData['sourceLatLng']['longitude']?.toDouble() ?? 0.0;
          double destLat =
              busData['destinationLatLng']['latitude']?.toDouble() ?? 0.0;
          double destLng =
              busData['destinationLatLng']['longitude']?.toDouble() ?? 0.0;

          _sourceLocation = LatLng(sourceLat, sourceLng);
          _destinationLocation = LatLng(destLat, destLng);

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
              Marker(
                markerId: MarkerId('sourceLocation'),
                position: _sourceLocation!,
                infoWindow: InfoWindow(title: "Source"),
              ),
              Marker(
                markerId: MarkerId('destinationLocation'),
                position: _destinationLocation!,
                infoWindow: InfoWindow(title: "Destination"),
              ),
            },
            polylines: {
              if (_sourceLocation != null && _destinationLocation != null)
                Polyline(
                  polylineId: PolylineId('route'),
                  points: [_sourceLocation!, _destinationLocation!],
                  color: Colors.blue,
                  width: 5,
                ),
            },
            onMapCreated: _onMapCreated,
          );
        },
      ),
    );
  }
}
