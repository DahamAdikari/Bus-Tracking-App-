import 'dart:async';
//not in use
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:test_4/consts.dart';

class MapPageDriver extends StatefulWidget {
  const MapPageDriver({super.key});

  @override
  State<MapPageDriver> createState() => _MapPageDriverState();
}

class _MapPageDriverState extends State<MapPageDriver> {
  //Initial position for InitialCameraPosition
  static const LatLng _pGooglePlex = LatLng(7.4818, 80.3609);
  //for markers
  static const LatLng _pApplePark = LatLng(7.4624, 80.3467);
  //
  LatLng? _currentP = null; //currentPosition

  //for get the location of the user
  Location _locationController = new Location();

  //for move camera with the user
  final Completer<GoogleMapController> _mapController =
      Completer<GoogleMapController>();

  //for polyline
  Map<PolylineId, Polyline> polylines = {};

  @override
  void initState() {
    super.initState();
    getLocationUpdates().then(
      (_) => {
        getPolylinePoints().then((coordinates) => {
              generatePolyLineFromPoints(coordinates),
            }),
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _currentP == null
          ? const Center(
              child: Text("Loading..."),
            )
          //if current position null it shows loading. this uses to identify whether current position is null
          : GoogleMap(
              onMapCreated: ((GoogleMapController controller) =>
                  _mapController.complete(controller)),
              initialCameraPosition: CameraPosition(
                target: _pGooglePlex,
                zoom: 13,
              ),
              markers: {
                Marker(
                    markerId: MarkerId("_currentLocation"),
                    icon: BitmapDescriptor.defaultMarkerWithHue(
                        BitmapDescriptor.hueBlue),
                    position: _currentP!),
                Marker(
                    markerId: MarkerId("_sourceLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pGooglePlex),
                Marker(
                    markerId: MarkerId("_destinationLocation"),
                    icon: BitmapDescriptor.defaultMarker,
                    position: _pApplePark)
              },
              polylines: Set<Polyline>.of(polylines.values),
            ),
    );
  }

  //For camera position
  Future<void> _cameraToPosition(LatLng pos) async {
    final GoogleMapController controller = await _mapController.future;
    CameraPosition _newCameraPosition = CameraPosition(
      target: pos,
      zoom: 13,
    );
    await controller
        .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));

    // Delay for 1 minute (60 seconds)
    Future.delayed(Duration(minutes: 1), () async {
      // Move the camera back to the original position
      await controller
          .animateCamera(CameraUpdate.newCameraPosition(_newCameraPosition));
    });
  }

  //To update the location
  Future<void> getLocationUpdates() async {
    bool
        _serviceEnabled; // Variable to check if the location service is enabled
    PermissionStatus
        _permissionGranted; // Variable to store the status of location permissions

    // Check if location services are enabled on the device
    _serviceEnabled =
        await _locationController.serviceEnabled(); //checks location is enabled
    if (_serviceEnabled) {
      _serviceEnabled = await _locationController
          .requestService(); //requesting for activation of location
    } else {
      return;
    }

    _permissionGranted = await _locationController.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _locationController
          .requestPermission(); //request permission to enable location
      if (_permissionGranted != PermissionStatus.granted) {
        return; //if user suddenly unable the location app while using the app
      }
    }

    // Listen for location updates as the user's location changes
    _locationController.onLocationChanged
        .listen((LocationData currentLocation) {
      if (currentLocation.latitude != null &&
          currentLocation.longitude != null) {
        setState(() {
          // Update the current position using LatLng with non-nullable values
          _currentP = LatLng(
              currentLocation.latitude!,
              currentLocation
                  .longitude!); //'!' is the null checker that confirms the value is not null
          print(_currentP);
          //_cameraToPosition(_currentP!); //set camera position while user moving

          // Update the driver's location in Firebase
          FirebaseFirestore.instance.collection('drivers').doc('Sahan').set({
            'latitude': _currentP!.latitude,
            'longitude': _currentP!.longitude,
          });
        });
      }
    });
  }

//for make polyline
  Future<List<LatLng>> getPolylinePoints() async {
    List<LatLng> polylineCoordinates = [];
    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
        googleApiKey: GOOGLE_MAPS_API_KEY,
        request: PolylineRequest(
            origin: PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
            destination:
                PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
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

  //generate polyline
  void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
    PolylineId id = PolylineId("poly");
    Polyline polyline = Polyline(
        polylineId: id,
        color: Colors.blue,
        points: polylineCoordinates,
        width: 8);
    setState(() {
      polylines[id] = polyline;
    });
  }
}
