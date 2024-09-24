import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'busdetails_passenger.dart';

class BusListPagePassenger extends StatefulWidget {
  final String source;
  final String destination;

  BusListPagePassenger({required this.source, required this.destination});

  @override
  _BusListPagePassengerState createState() => _BusListPagePassengerState();
}

class _BusListPagePassengerState extends State<BusListPagePassenger> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Buses'),
        backgroundColor: Color(0xFF00A9CE), // Sea blue color
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {}); // Triggers UI refresh and re-fetches data
            },
          ),
        ],
      ),
      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _fetchBusesRealTime(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
              child: Text('No buses found matching your criteria.'),
            );
          }

          var busDocuments = snapshot.data!;

          // Filter buses based on source, destination, and bus halts
          var filteredBuses = busDocuments.where((busData) {
            var busSource = busData['bus']['sourceLocation'];
            var busDestination = busData['bus']['destinationLocation'];
            var busHalts = busData['bus']['busHalts'] as List<dynamic>;

            bool matchesDirectly = (busSource == widget.source &&
                busDestination == widget.destination);
            bool matchesIndirectly =
                busHalts.any((halt) => halt['name'] == widget.source) &&
                    busDestination == widget.destination;

            return matchesDirectly || matchesIndirectly;
          }).toList();

          if (filteredBuses.isEmpty) {
            return Center(
              child: Text('No buses found matching your criteria.'),
            );
          }

          return ListView.builder(
            itemCount: filteredBuses.length,
            itemBuilder: (context, index) {
              var busData = filteredBuses[index];

              bool isOnline = busData['bus']['isOnline'] ?? false;
              bool onWay = busData['bus']['onWay'] ?? false;

              return Container(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400, width: 1),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: ListTile(
                  leading: Image.asset(
                    isOnline
                        ? 'assets/images/passengerTiles/GreenBus.png'
                        : 'assets/images/passengerTiles/BlackBus.png',
                    alignment: Alignment.center,
                    width: 50,
                    height: 50,
                  ),
                  title: Text(
                    '${busData['bus']['sourceLocation']} -> ${busData['bus']['destinationLocation']}',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Route Number: ${busData['bus']['routeNum']}'),
                      if (onWay)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Stack(
                            children: [
                              // Text with a border (underlying text)
                              Text(
                                'On the way to source',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  foreground: Paint()
                                    ..style = PaintingStyle.stroke
                                    ..strokeWidth = 2.0
                                    ..color = Colors.black, // Border color
                                  letterSpacing: 1.2,
                                ),
                              ),
                              // Main text with no border (foreground text)
                              Text(
                                'On the way to source',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orangeAccent,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isOnline ? 'ONLINE' : 'OFFLINE',
                        style: TextStyle(
                          fontSize: 15,
                          color: isOnline ? Colors.green : Colors.grey,
                          fontWeight: FontWeight.bold,
                          shadows: isOnline
                              ? [Shadow(blurRadius: 10.0, color: Colors.green)]
                              : null,
                        ),
                      ),
                    ],
                  ),
                  isThreeLine: true,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BusDetailsPagePassenger(
                          busId: busData['bus'].id,
                          driverId: busData['driverId'],
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }

  Stream<List<Map<String, dynamic>>> _fetchBusesRealTime() async* {
    List<Map<String, dynamic>> buses = [];

    // Get all driver documents in real-time
    Stream<QuerySnapshot> driverStream =
        FirebaseFirestore.instance.collection('driver').snapshots();

    await for (var driverSnapshot in driverStream) {
      buses.clear();
      for (var driverDoc in driverSnapshot.docs) {
        // Get the buses subcollection for each driver in real-time
        QuerySnapshot busSnapshot =
            await driverDoc.reference.collection('buses').get();

        for (var busDoc in busSnapshot.docs) {
          buses.add({
            'bus': busDoc,
            'driverId': driverDoc.id,
          });
        }
      }
      yield buses;
    }
  }
}
