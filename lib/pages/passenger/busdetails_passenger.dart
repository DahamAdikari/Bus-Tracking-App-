import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/pages/passenger/busmap_passenger.dart';
import 'package:test_4/pages/passenger/seat_booking.dart';

class BusDetailsPagePassenger extends StatefulWidget {
  final String busId;
  final String driverId;

  BusDetailsPagePassenger({required this.busId, required this.driverId});

  @override
  _BusDetailsPagePassengerState createState() =>
      _BusDetailsPagePassengerState();
}

class _BusDetailsPagePassengerState extends State<BusDetailsPagePassenger> {
  late Stream<DocumentSnapshot> _busStream;

  @override
  void initState() {
    super.initState();
    _busStream = FirebaseFirestore.instance
        .collection('driver')
        .doc(widget.driverId)
        .collection('buses')
        .doc(widget.busId)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _busStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: Text('Bus details not found.'));
          }

          var busData = snapshot.data!;
          double latitude = busData['latitude']?.toDouble() ?? 0.0;
          double longitude = busData['longitude']?.toDouble() ?? 0.0;
          LatLng busPosition = LatLng(latitude, longitude);

          return SingleChildScrollView(
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
                Text('Bus Halts:', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                busData['busHalts']?.isEmpty ?? true
                    ? Text('No bus halts', style: TextStyle(fontSize: 18))
                    : Container(
                        height: 200,
                        child: ListView.builder(
                          itemCount: busData['busHalts']?.length ?? 0,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(busData['busHalts'][index]['name']),
                            );
                          },
                        ),
                      ),
                SizedBox(height: 20),
                Container(
                  height: 300, // Set a fixed height for the map
                  child: GoogleMap(
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
                    onMapCreated: (controller) {
                      // Add map created logic here if needed
                    },
                    // Update the camera position whenever the location changes
                    myLocationEnabled: true,
                    myLocationButtonEnabled: true,
                    onCameraMove: (position) {
                      // Handle camera move if necessary
                    },
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusFullMapPage(
                                busId: widget.busId, driverId: widget.driverId),
                          ),
                        );
                      },
                      child: Text('View Full Map'),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SeatBooking(
                                busId: widget.busId, driverId: widget.driverId),
                          ),
                        );
                      },
                      child: Text('Book My Seat'),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
