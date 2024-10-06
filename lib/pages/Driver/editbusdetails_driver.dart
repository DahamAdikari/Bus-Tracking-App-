import 'dart:async';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_4/pages/Driver/Addbushalt_driver.dart';
import 'package:test_4/pages/Driver/editseats_driver.dart';

class EditBusDetails extends StatefulWidget {
  final String busId;
  final String userID;

  EditBusDetails({required this.busId, required this.userID});

  @override
  _EditBusDetailsState createState() => _EditBusDetailsState();
}

class _EditBusDetailsState extends State<EditBusDetails> {
  final TextEditingController _busNameController = TextEditingController();
  final TextEditingController _routeNumController = TextEditingController();
  final TextEditingController _sourceLocationController =
      TextEditingController();
  final TextEditingController _destinationLocationController =
      TextEditingController();
  late StreamSubscription<DocumentSnapshot> _busStreamSubscription;
  late Stream<DocumentSnapshot> _busStream;

  List<dynamic> seatLayout = [];

  @override
  void initState() {
    super.initState();
    _busStream = FirebaseFirestore.instance
        .collection('driver')
        .doc(widget.userID)
        .collection("buses")
        .doc(widget.busId)
        .snapshots();
    _busStreamSubscription = _busStream.listen((snapshot) {
      if (snapshot.exists) {
        _updateBusDetails(snapshot);
      }
    });
  }

  @override
  void dispose() {
    _busStreamSubscription.cancel();
    _busNameController.dispose();
    _routeNumController.dispose();
    _sourceLocationController.dispose();
    _destinationLocationController.dispose();
    super.dispose();
  }

  Future<void> _updateBusDetails(DocumentSnapshot snapshot) async {
    setState(() {
      _busNameController.text = snapshot['busName'] ?? '';
      _routeNumController.text = snapshot['routeNum'] ?? '';
      _sourceLocationController.text = snapshot['sourceLocation'] ?? '';
      _destinationLocationController.text =
          snapshot['destinationLocation'] ?? '';
      seatLayout = List.from(snapshot['seatLayout'] ?? []);
    });
  }

  Future<void> _saveChanges() async {
    await FirebaseFirestore.instance
        .collection('driver')
        .doc(widget.userID)
        .collection("buses")
        .doc(widget.busId)
        .update({
      'busName': _busNameController.text,
      'routeNum': _routeNumController.text,
      'sourceLocation': _sourceLocationController.text,
      'destinationLocation': _destinationLocationController.text,
      'seatLayout': seatLayout,
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Bus details updated successfully!')),
    );

    // Navigate back to the previous page and return true to indicate that changes were made
    Navigator.pop(context, true);
  }

  void _deleteBusHalt(int haltIndex) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('buses')
        .doc(widget.busId)
        .get();

    List<dynamic> busHalts = List.from(doc['busHalts']);
    if (haltIndex >= 0 && haltIndex < busHalts.length) {
      busHalts.removeAt(haltIndex);

      await FirebaseFirestore.instance
          .collection('driver')
          .doc(widget.userID)
          .collection("buses")
          .doc(widget.busId)
          .update({
        'busHalts': busHalts,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Bus halt deleted successfully!')),
      );
    }
  }

  void _addBusHalt() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddBusHaltPageDriver(busId: widget.busId),
      ),
    );

    if (result != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('driver')
          .doc(widget.userID)
          .collection("buses")
          .doc(widget.busId)
          .get();

      List<dynamic> busHalts = List.from(doc['busHalts']);
      busHalts.add(result);

      await FirebaseFirestore.instance
          .collection('driver')
          .doc(widget.userID)
          .collection("buses")
          .doc(widget.busId)
          .update({
        'busHalts': busHalts,
      });
    }
  }

  void _editSeats() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SeatLayoutPage(
          busId: widget.busId,
          userID: widget.userID,
        ),
      ),
    );
    // Check if result is not null and a Map type, and then flatten it
    if (result != null) {
      if (result is List<List<Map<String, dynamic>>>) {
        // If result is a nested list, flatten it
        setState(() {
          seatLayout = flattenSeatLayout(result);
        });
      }
    }
  }

  // Helper function to flatten seat layout
  List<Map<String, dynamic>> flattenSeatLayout(
      List<List<Map<String, dynamic>>> seatLayout) {
    List<Map<String, dynamic>> flatList = [];

    for (int row = 0; row < seatLayout.length; row++) {
      for (int col = 0; col < seatLayout[row].length; col++) {
        Map<String, dynamic> seat = seatLayout[row][col];
        flatList.add({
          'row': row,
          'col': col,
          'status': seat['status'],
        });
      }
    }
    return flatList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Bus Details'),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: _busStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          var busData = snapshot.data!;
          var busHalts = List.from(busData['busHalts'] ?? []);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _busNameController,
                  decoration: InputDecoration(labelText: 'Bus Name'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _routeNumController,
                  decoration: InputDecoration(labelText: 'Route Number'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _sourceLocationController,
                  decoration: InputDecoration(labelText: 'Source Location'),
                ),
                SizedBox(height: 10),
                TextField(
                  controller: _destinationLocationController,
                  decoration:
                      InputDecoration(labelText: 'Destination Location'),
                ),
                SizedBox(height: 20),
                Text('Bus Halts:', style: TextStyle(fontSize: 18)),
                SizedBox(height: 10),
                Container(
                  height: 200, // Adjust height as needed
                  child: ListView.builder(
                    itemCount: busHalts.length,
                    itemBuilder: (context, index) {
                      var halt = busHalts[index];
                      return ListTile(
                        title: Text(halt['name']),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () {
                            _deleteBusHalt(index);
                          },
                        ),
                      );
                    },
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _addBusHalt,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlue, // Text color
                  ),
                  child: Text('Add Bus Halt'),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed:  _editSeats,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.lightBlue, // Text color
                    ),
                    child: Text('Edit Seats'),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: _saveChanges,
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.lightBlue, // Text color
                    ),
                    child: Text('Save Changes'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
