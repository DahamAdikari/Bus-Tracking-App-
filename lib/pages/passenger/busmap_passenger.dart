import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_directions/google_maps_directions.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:test_4/auth/constants/colors.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:test_4/consts.dart';
import "package:google_maps_directions/google_maps_directions.dart" as gmd;
import 'package:flutter_polyline_points/flutter_polyline_points.dart';

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
  final LatLng source;
  final LatLng dest;

  BusFullMapPage(
      {required this.busId,
      required this.driverId,
      required this.source,
      required this.dest});

  @override
  _BusFullMapPageState createState() => _BusFullMapPageState();
}

class _BusFullMapPageState extends State<BusFullMapPage> {
  Location _location = Location();
  LatLng? _userLocation;

  Map<PolylineId, Polyline> polylines = {};
  Set<Polyline> _mapPolylines = {};
  GoogleMapController? _mapController;
  BitmapDescriptor? customIcon;

  Stream<DocumentSnapshot>? _busStream;
  //List<LatLng> _polylinePoints = [];
  String googleApikey = GOOGLE_MAPS_API_KEY;

  List<LatLng> _routePoints = [];

  @override
  void initState() {
    print("sasdsa");
    super.initState();
    _busStream = _getBusStream();
    _getUserLocation();
    _loadCustomIcon();
    getPolylinepoints()
        .then((coordinates) => {generatepolylinefrompoints(coordinates)});
  }

  Future<void> _fetchRoute(LatLng source, LatLng destination) async {
    try {
      Directions directions = await getDirections(
        source.latitude,
        source.longitude,
        destination.latitude,
        destination.longitude,
        language: "en", // Change to "fr_FR" for French if needed
      );

      print("11111111111111111");

      DirectionRoute route = directions.shortestRoute;

      List<LatLng> points = PolylinePoints()
          .decodePolyline(route.overviewPolyline.points)
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      Polyline polylines = Polyline(
        width: 5,
        polylineId: PolylineId("UNIQUE_ROUTE_ID"),
        color: Colors.green,
        points: points,
      );

      setState(() {
        _mapPolylines = {polylines}; // Update the polylines set
      });
    } catch (e) {
      print("Error fetching directions: $e");
    }
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

  // Load the custom icon
  void _loadCustomIcon() async {
    BitmapDescriptor icon = await BitmapDescriptor.asset(
      ImageConfiguration(size: Size(48, 48)), // Adjust size if needed
      'assets/images/bus.png', // Path to your image asset
    );
    setState(() {
      customIcon = icon;
    });
  }

  // Future<void> _fetchRoute(LatLng source, LatLng destination) async {
  //   try {
  //     final String url =
  //         "https://maps.googleapis.com/maps/api/directions/json?origin=${source.latitude},${source.longitude}&destination=${destination.latitude},${destination.longitude}&key=$googleApikey";
  //     final response = await http.get(Uri.parse(url));

  //     if (response.statusCode == 200) {
  //       final data = json.decode(response.body);
  //       final route = data['routes'][0]['overview_polyline']['points'];
  //       if (route == null || route.isEmpty) {
  //         print("No polyline data found");
  //         return;
  //       } else {
  //         print("polyline is here");
  //       }

  //       setState(() {
  //         _polylinePoints = _decodePolyline(route);
  //       });
  //     } else {
  //       debugPrint("Error fetching directions: ${response.body}");
  //     }
  //   } catch (e) {
  //     debugPrint("Error1: $e");
  //   }
  // }

  // List<LatLng> _decodePolyline(String encoded) {
  //   List<LatLng> points = [];
  //   int index = 0, len = encoded.length;
  //   int lat = 0, lng = 0;

  //   while (index < len) {
  //     int shift = 0, result = 0;
  //     int b;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1f) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dLat = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
  //     lat += dLat;

  //     shift = 0;
  //     result = 0;
  //     do {
  //       b = encoded.codeUnitAt(index++) - 63;
  //       result |= (b & 0x1f) << shift;
  //       shift += 5;
  //     } while (b >= 0x20);
  //     int dLng = (result & 1) != 0 ? ~(result >> 1) : (result >> 1);
  //     lng += dLng;

  //     points.add(LatLng(lat / 1E5, lng / 1E5));
  //   }

  //   return points;
  // }

  void _moveCamera(LatLng position) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLng(position),
    );
  }

  Future<void> _getUserLocation() async {
    // Check if location service is enabled
    bool _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        // Show error message or handle accordingly
        return;
      }
    }

    // Request permission to access location
    PermissionStatus _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        // Handle permission denial
        return;
      }
    }

    // Get current location
    var locationData = await _location.getLocation();
    setState(() {
      _userLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });

    if (_mapController != null && _userLocation != null) {
      _mapController!
          .animateCamera(CameraUpdate.newLatLngZoom(_userLocation!, 14));
    }
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
          // double sourceLatitude =
          //     busData['sourceLatLng']['latitude']?.toDouble() ?? 0.0;
          // double sourceLongitude =
          //     busData['sourceLatLng']['longitude']?.toDouble() ?? 0.0;
          // double destinationLatitude =
          //     busData['destinationLatLng']['latitude']?.toDouble() ?? 0.0;
          // double destinationLongitude =
          //     busData['destinationLatLng']['longitude']?.toDouble() ?? 0.0;

          //POLYLINE
          //_fetchRoute(sourceLocation, destinationLocation);

          // Add polyline points
          //_polylinePoints = [sourceLocation, destinationLocation];

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
                infoWindow: InfoWindow(title: "Bus Current Location"),
                icon: customIcon ?? BitmapDescriptor.defaultMarker,
              ),
              Marker(
                markerId: MarkerId('source'),
                position: widget.source,
                infoWindow: InfoWindow(title: "Source"),
              ),
              Marker(
                markerId: MarkerId('destination'),
                position: widget.dest,
                infoWindow: InfoWindow(title: "Destination"),
              ),
            },
            polylines: Set<Polyline>.of(polylines.values),
            myLocationEnabled: true,
            myLocationButtonEnabled: true,
            onMapCreated: _onMapCreated,
          );
        },
      ),
    );
  }

  void generatepolylinefrompoints(List<LatLng> polylineCoordinates1) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates1,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }

  Future<List<LatLng>> getPolylinepoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: googleApikey,
        request: PolylineRequest(
            origin:
                PointLatLng(widget.source.latitude, widget.source.longitude),
            destination:
                PointLatLng(widget.dest.latitude, widget.dest.longitude),
            mode: TravelMode.driving));
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    } else {
      print(result.errorMessage);
    }
    return polylineCoordinates;
  }
}
