import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'busdetails_passenger.dart';

class BusListPagePassenger extends StatelessWidget {
  final String source;
  final String destination;

  BusListPagePassenger({required this.source, required this.destination});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Available Buses'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _fetchBuses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(
                child: Text('No buses found matching your criteria.'));
          }

          var busDocuments = snapshot.data!;

          // Filter buses based on source, destination, and bus halts
          var filteredBuses = busDocuments.where((busData) {
            var busSource = busData['bus']['sourceLocation'];
            var busDestination = busData['bus']['destinationLocation'];
            var busHalts = busData['bus']['busHalts'] as List<dynamic>;

            bool matchesDirectly =
                (busSource == source && busDestination == destination);
            bool matchesIndirectly =
                busHalts.any((halt) => halt['name'] == source) &&
                    busDestination == destination;

            return matchesDirectly || matchesIndirectly;
          }).toList();

          if (filteredBuses.isEmpty) {
            return Center(
                child: Text('No buses found matching your criteria.'));
          }

          return ListView.builder(
            itemCount: filteredBuses.length,
            itemBuilder: (context, index) {
              var busData = filteredBuses[index];

              return ListTile(
                title: Text('Bus: ${busData['bus']['busName']}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Route Number: ${busData['bus']['routeNum']}'),
                    SizedBox(height: 10),
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
              );
            },
          );
        },
      ),
    );
  }

  Future<List<Map<String, dynamic>>> _fetchBuses() async {
    List<Map<String, dynamic>> buses = [];

    // Get all driver documents
    QuerySnapshot driverSnapshot =
        await FirebaseFirestore.instance.collection('driver').get();

    for (var driverDoc in driverSnapshot.docs) {
      // Get the buses subcollection for each driver
      QuerySnapshot busSnapshot =
          await driverDoc.reference.collection('buses').get();
      for (var busDoc in busSnapshot.docs) {
        buses.add({
          'bus': busDoc,
          'driverId': driverDoc.id,
        });
      }
    }

    return buses;
  }
}
