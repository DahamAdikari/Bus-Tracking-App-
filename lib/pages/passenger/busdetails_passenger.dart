import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:test_4/auth/constants/colors.dart';
import 'package:test_4/pages/Useless/busruteAdmin.dart';
import 'package:test_4/pages/passenger/busmap_passenger.dart';
import 'package:test_4/pages/passenger/seat_booking.dart';

// class BusDetailsPagePassenger extends StatefulWidget {
//   final String busId;
//   final String driverId;

//   BusDetailsPagePassenger({required this.busId, required this.driverId});

//   @override
//   _BusDetailsPagePassengerState createState() =>
//       _BusDetailsPagePassengerState();
// }

// class _BusDetailsPagePassengerState extends State<BusDetailsPagePassenger> {
//   late Stream<DocumentSnapshot> _busStream;

//   @override
//   void initState() {
//     super.initState();
//     _busStream = FirebaseFirestore.instance
//         .collection('driver')
//         .doc(widget.driverId)
//         .collection('buses')
//         .doc(widget.busId)
//         .snapshots();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bus Details'),
//       ),
//       body: StreamBuilder<DocumentSnapshot>(
//         stream: _busStream,
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return Center(child: CircularProgressIndicator());
//           }

//           if (!snapshot.hasData || !snapshot.data!.exists) {
//             return Center(child: Text('Bus details not found.'));
//           }

//           var busData = snapshot.data!;
//           double latitude = busData['latitude']?.toDouble() ?? 0.0;
//           double longitude = busData['longitude']?.toDouble() ?? 0.0;
//           LatLng busPosition = LatLng(latitude, longitude);

//           bool bookingAvailable = busData['bookingAvailable'] ?? false;

//           return SingleChildScrollView(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Bus Name: ${busData['busName']}',
//                     style: TextStyle(fontSize: 18)),
//                 SizedBox(height: 10),
//                 Text('Route Number: ${busData['routeNum']}',
//                     style: TextStyle(fontSize: 18)),
//                 SizedBox(height: 10),
//                 Text('Source Location: ${busData['sourceLocation']}',
//                     style: TextStyle(fontSize: 18)),
//                 SizedBox(height: 10),
//                 Text('Destination Location: ${busData['destinationLocation']}',
//                     style: TextStyle(fontSize: 18)),
//                 SizedBox(height: 20),
//                 Text('Bus Halts:', style: TextStyle(fontSize: 18)),
//                 SizedBox(height: 10),
//                 busData['busHalts']?.isEmpty ?? true
//                     ? Text('No bus halts', style: TextStyle(fontSize: 18))
//                     : Container(
//                         height: 200,
//                         child: ListView.builder(
//                           itemCount: busData['busHalts']?.length ?? 0,
//                           itemBuilder: (context, index) {
//                             return ListTile(
//                               title: Text(busData['busHalts'][index]['name']),
//                             );
//                           },
//                         ),
//                       ),
//                 SizedBox(height: 20),
//                 Container(
//                   height: 300, // Set a fixed height for the map
//                   child: GoogleMap(
//                     initialCameraPosition: CameraPosition(
//                       target: busPosition,
//                       zoom: 14,
//                     ),
//                     markers: {
//                       Marker(
//                         markerId: MarkerId('busLocation'),
//                         position: busPosition,
//                       ),
//                     },
//                     onMapCreated: (controller) {
//                       // Add map created logic here if needed
//                     },
//                     // Update the camera position whenever the location changes
//                     myLocationEnabled: true,
//                     myLocationButtonEnabled: true,
//                     onCameraMove: (position) {
//                       // Handle camera move if necessary
//                     },
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     ElevatedButton(
//                       onPressed: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => BusFullMapPage(
//                                 busId: widget.busId, driverId: widget.driverId),
//                           ),
//                         );
//                       },
//                       child: Text('View Full Map'),
//                     ),
//                     ElevatedButton(
//                       onPressed: () {
//                         if (bookingAvailable) {
//                           Navigator.push(
//                             context,
//                             MaterialPageRoute(
//                               builder: (context) => SeatBooking(
//                                   busId: widget.busId,
//                                   driverId: widget.driverId),
//                             ),
//                           );
//                         } else {
//                           // Show snackbar message when booking is not available
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             SnackBar(
//                               content: Text(
//                                 'Booking is not available for this bus.',
//                                 style: TextStyle(color: Colors.white),
//                               ),
//                               backgroundColor: Colors.red,
//                               duration: Duration(seconds: 3),
//                             ),
//                           );
//                         }
//                       },
//                       child: Text('Book My Seat'),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           );
//         },
//       ),
//     );
//   }
// }
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
        title: Text(
          'Bus Details',
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

          bool bookingAvailable = busData['bookingAvailable'] ?? false;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  elevation: 5,
                  margin: EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  color: bOnBoardingColor1, // White background for card
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bus Name: ${busData['busName']}',
                            style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: tPrimaryColor)),
                        SizedBox(height: 8),
                        Text('Route Number: ${busData['routeNum']}',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text('Source Location: ${busData['sourceLocation']}',
                            style: TextStyle(fontSize: 16)),
                        SizedBox(height: 8),
                        Text(
                            'Destination Location: ${busData['destinationLocation']}',
                            style: TextStyle(fontSize: 16)),
                      ],
                    ),
                  ),
                ),
                Text('Bus Halts',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: tPrimaryColor)),
                SizedBox(height: 10),
                busData['busHalts']?.isEmpty ?? true
                    ? Text('No bus halts', style: TextStyle(fontSize: 16))
                    : Container(
                        height: 150,
                        child: ListView.builder(
                          itemCount: busData['busHalts']?.length ?? 0,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: EdgeInsets.only(bottom: 8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              color:
                                  bOnBoardingColor2, // Light blue background for each halt
                              child: ListTile(
                                title: Text(busData['busHalts'][index]['name'],
                                    style: TextStyle(
                                        fontSize: 16, color: tDarkColor)),
                              ),
                            );
                          },
                        ),
                      ),
                SizedBox(height: 20),
                Container(
                  height: 250, // Set a fixed height for the map
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    gradient: LinearGradient(
                      colors: [bOnBoardingColor2, bOnBoardingColor3],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
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
                      myLocationEnabled: true,
                      myLocationButtonEnabled: true,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BusFullMapPage(
                                busId: widget.busId, driverId: widget.driverId),
                          ),
                        );
                      },
                      icon: Icon(Icons.map, size: 20, color: tWhiteColor),
                      label: Text('View Full Map',
                          style: TextStyle(color: tWhiteColor)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tPrimaryColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        if (bookingAvailable) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SeatBooking(
                                  busId: widget.busId,
                                  driverId: widget.driverId),
                            ),
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                'Booking is not available for this bus.',
                                style: TextStyle(color: Colors.white),
                              ),
                              backgroundColor: Colors.red,
                              duration: Duration(seconds: 3),
                            ),
                          );
                        }
                      },
                      icon:
                          Icon(Icons.book_online, size: 20, color: tWhiteColor),
                      label: Text('Book My Seat',
                          style: TextStyle(color: tWhiteColor)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: tAccentColor,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ],
                ),
                // ElevatedButton.icon(
                //   onPressed: () {
                //     Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => AdminRouteCreationPage(
                //           busId: '',
                //         ),
                //       ),
                //     );
                //   },
                //   icon: Icon(Icons.map, size: 20, color: tWhiteColor),
                //   label: Text('test', style: TextStyle(color: tWhiteColor)),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: tPrimaryColor,
                //     padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                //     shape: RoundedRectangleBorder(
                //       borderRadius: BorderRadius.circular(8),
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        },
      ),
    );
  }
}
