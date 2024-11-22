import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;

class AdminRouteCreationPage extends StatefulWidget {
  final String busId;

  AdminRouteCreationPage({required this.busId});

  @override
  _AdminRouteCreationPageState createState() => _AdminRouteCreationPageState();
}

class _AdminRouteCreationPageState extends State<AdminRouteCreationPage> {
  GoogleMapController? _mapController;
  List<LatLng> _routePoints = [];
  List<LatLng> _polylinePoints = [];

  void _onMapTapped(LatLng point) async {
    if (_routePoints.isNotEmpty) {
      // Fetch road route between last point and new point
      LatLng lastPoint = _routePoints.last;
      List<LatLng> routeSegment = await _fetchRouteFromGoogle(lastPoint, point);

      setState(() {
        _polylinePoints
            .addAll(routeSegment); // Add the route segment to polyline
      });
    }

    setState(() {
      _routePoints.add(point); // Add the new point
    });
  }

  Future<List<LatLng>> _fetchRouteFromGoogle(LatLng start, LatLng end) async {
    const String apiKey =
        '<YOUR_GOOGLE_MAPS_API_KEY>'; // Replace with your Google Maps API Key
    String url =
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey&mode=driving';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'] != null && data['routes'].isNotEmpty) {
        String encodedPolyline =
            data['routes'][0]['overview_polyline']['points'];
        return _decodePolyline(encodedPolyline);
      }
    }
    return [start, end]; // Fallback to a straight line if the API fails
  }

  List<LatLng> _decodePolyline(String polyline) {
    List<LatLng> points = [];
    int index = 0, len = polyline.length;
    int lat = 0, lng = 0;

    while (index < len) {
      int shift = 0, result = 0;
      int byte;
      do {
        byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int deltaLat = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lat += deltaLat;

      shift = 0;
      result = 0;
      do {
        byte = polyline.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      int deltaLng = ((result & 1) != 0 ? ~(result >> 1) : (result >> 1));
      lng += deltaLng;

      points.add(LatLng(lat / 1E5, lng / 1E5));
    }
    return points;
  }

  void _undoLastPoint() {
    if (_routePoints.isNotEmpty) {
      setState(() {
        _routePoints.removeLast(); // Remove the last point
        // Recalculate the polyline based on remaining points
        _polylinePoints.clear();
        for (int i = 0; i < _routePoints.length - 1; i++) {
          _fetchRouteFromGoogle(_routePoints[i], _routePoints[i + 1])
              .then((routeSegment) {
            setState(() {
              _polylinePoints.addAll(routeSegment);
            });
          });
        }
      });
    }
  }

  void _saveRouteToFirestore() async {
    try {
      // Save the route to Firestore under the bus's document
      await FirebaseFirestore.instance
          .collection('routes')
          .doc(widget.busId)
          .set({
        'points': _routePoints
            .map((point) => {'lat': point.latitude, 'lng': point.longitude})
            .toList(),
      });

      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Route saved successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Failed to save route: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Bus Route'),
        backgroundColor: Colors.blue,
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveRouteToFirestore,
          ),
        ],
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: LatLng(6.9271, 79.8612), // Default position (Colombo)
              zoom: 14,
            ),
            onMapCreated: (controller) => _mapController = controller,
            onTap: _onMapTapped,
            polylines: {
              Polyline(
                polylineId: PolylineId('route'),
                points: _polylinePoints,
                color: Colors.blue,
                width: 4,
              ),
            },
            markers: _routePoints
                .map((point) => Marker(
                      markerId: MarkerId(point.toString()),
                      position: point,
                    ))
                .toSet(),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            child: FloatingActionButton(
              onPressed: _undoLastPoint,
              child: Icon(Icons.undo),
              backgroundColor: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
