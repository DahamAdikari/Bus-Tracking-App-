import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeatLayoutPage extends StatefulWidget {
  final String busId;
  final String userID;

  SeatLayoutPage({required this.busId, required this.userID});

  @override
  _SeatLayoutPageState createState() => _SeatLayoutPageState();
}

class _SeatLayoutPageState extends State<SeatLayoutPage> {
  Map<String, dynamic>? seatData; // Seat data fetched from Firestore
  bool _isLoading = true; // To track if data is being fetched
  int _crossAxisCount = 4; // Default number of columns
  double _crossAxisSpacing = 10.0; // Default cross-axis spacing
  double _mainAxisSpacing = 10.0; // Default main-axis spacing
  List<int> _selectedSeats = []; // List to track selected seats by index

  @override
  void initState() {
    super.initState();
    _fetchSeatData(); // Fetch seat data on initialization
  }

  Future<void> _fetchSeatData() async {
    try {
      // Fetch the seat data from the Firebase document
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('driver')
          .doc(widget.userID)
          .collection('buses')
          .doc(widget.busId)
          .get();

      if (doc.exists && doc.data() != null) {
        var data = doc.data() as Map<String, dynamic>;

        setState(() {
          seatData = data['seatData'] ?? {}; // Ensure seatData is not null
          _isLoading = false; // Data fetched, stop loading
          _setLayoutBasedOnModel(); // Adjust the layout based on the model
        });
      } else {
        print("Document does not exist or has no seat data.");
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching seat data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  // Function to set layout based on seat model (stored as a number in Firebase)
  void _setLayoutBasedOnModel() {
    int seatModel = seatData!['selectedModel']; // Fetch seat model (e.g., 1, 2, 3)

    switch (seatModel) {
      case 1: // 1 represents 1x2 model
        _crossAxisCount = 4; // 1x2 has 4 columns (1 seat, aisle, 2 seats)
        _crossAxisSpacing = 10.0;
        _mainAxisSpacing = 10.0;
        break;
      case 2: // 2 represents 2x2 model
        _crossAxisCount = 5; // 2x2 has 5 columns (2 seats, aisle, 2 seats)
        _crossAxisSpacing = 12.0;
        _mainAxisSpacing = 12.0;
        break;
      case 3: // 3 represents 2x3 model
        _crossAxisCount = 6; // 2x3 has 6 columns (2 seats, aisle, 3 seats)
        _crossAxisSpacing = 14.0;
        _mainAxisSpacing = 14.0;
        break;
      default:
        _crossAxisCount = 4; // Default fallback layout
        _crossAxisSpacing = 10.0;
        _mainAxisSpacing = 10.0;
    }
  }

  // Function to handle seat selection (toggle)
  void _toggleSeatSelection(int index) {
    setState(() {
      if (_selectedSeats.contains(index)) {
        _selectedSeats.remove(index); // Deselect seat if already selected
      } else {
        _selectedSeats.add(index); // Select seat
      }
    });
  }

  // Function to update seat status (block or clear)
  void _updateSeatStatus(String newStatus) {
    List<dynamic> updatedSeatLayout = List.from(seatData!['seatLayout']);
    bool hasInvalidSeats = false;

    for (int index in _selectedSeats) {
      String currentStatus = updatedSeatLayout[index]['status'];

      if (newStatus == 'blocked' && currentStatus != 'available') {
        // Show error if trying to block non-available seats
        hasInvalidSeats = true;
      } else if (newStatus == 'available' && currentStatus != 'booked') {
        // Show error if trying to clear non-booked seats
        hasInvalidSeats = true;
      } else {
        updatedSeatLayout[index]['status'] = newStatus;
      }
    }

    if (hasInvalidSeats) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Invalid operation. Please select the correct seat type.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    } else {
      setState(() {
        seatData!['seatLayout'] = updatedSeatLayout; // Update seat layout locally
        _selectedSeats.clear(); // Clear selection after update
      });
    }
  }

  // Function to reset all booked and blocked seats to 'available'
  void _resetSeats() {
    List<dynamic> updatedSeatLayout = List.from(seatData!['seatLayout']);

    for (int i = 0; i < updatedSeatLayout.length; i++) {
      if (updatedSeatLayout[i]['status'] == 'booked' || updatedSeatLayout[i]['status'] == 'blocked') {
        updatedSeatLayout[i]['status'] = 'available'; // Reset to 'available'
      }
    }

    setState(() {
      seatData!['seatLayout'] = updatedSeatLayout; // Update local data
      _selectedSeats.clear(); // Clear selection
    });
  }

  // Function to confirm seat selection and pass data back
  void _confirmSeats() {
    FirebaseFirestore.instance
        .collection('driver')
        .doc(widget.userID)
        .collection('buses')
        .doc(widget.busId)
        .update({
      'seatData': seatData,
    });

    Navigator.pop(context, seatData); // Navigate back and pass seat data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Seat Layout'),
        actions: [
          ElevatedButton(
            onPressed: () {
              _resetSeats(); // Call reset function on button press
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              foregroundColor: Colors.black, 
            ),
            child: Row(
              children: [
                Icon(Icons.refresh, color: Colors.black), // Add reset icon
                SizedBox(width: 4), // Space between icon and text
                Text(
                  'Reset',
                  style: TextStyle(fontSize: 16), // Customize text style
                ),
              ],
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Loading spinner
          : Column(
              children: [
                Expanded(child: _buildSeatLayout()), // Build seat layout
                _buildDriverControls(), // Add control buttons
                _buildConfirmButton(), // Add confirm button
              ],
            ),
    );
  }

  // Function to build seat layout based on the seatData fetched
  Widget _buildSeatLayout() {
    List<dynamic> seatLayout = seatData!['seatLayout'];

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount, // Dynamically set number of columns
        crossAxisSpacing: _crossAxisSpacing, // Dynamic cross-axis spacing
        mainAxisSpacing: _mainAxisSpacing, // Dynamic main-axis spacing
      ),
      itemCount: seatLayout.length, // Total number of seats
      itemBuilder: (context, index) {
        var seat = seatLayout[index];
        String status = seat['status'] ?? 'Unknown';

        bool isSelected = _selectedSeats.contains(index); // Check if selected
        Color seatColor;

        if (isSelected) {
          seatColor = Colors.blue; // Highlight selected seats in blue
        } else {
          seatColor = status == 'available'
              ? Colors.green
              : status == 'booked'
                  ? Colors.red
                  : status == 'blocked'
                      ? Colors.yellow
                      : Colors.grey; // Color coding based on seat status
        }

        return GestureDetector(
          onTap: () => _toggleSeatSelection(index), // Toggle seat selection
          child: Container(
            decoration: BoxDecoration(
              color: seatColor,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.yellow : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(
              child: Text(
                'Row: ${seat['row']}, Col: ${seat['col']}', 
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to build control buttons
  Widget _buildDriverControls() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildElevatedButton('Block Selected Seats', Colors.brown, () {
            _updateSeatStatus('blocked'); // Block selected seats
          }),
          _buildElevatedButton('Clear Selected Bookings', Colors.indigo, () {
            _updateSeatStatus('available'); // Clear bookings
          }),
        ],
      ),
    );
  }

  // Function to build a styled elevated button
  Widget _buildElevatedButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color, // Set the button color
        foregroundColor: Colors.white, // Set the text color
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10), // Add padding
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25), // Rounded corners
        ),
        elevation: 5, // Add elevation for shadow effect
      ),
      child: Text(
        text,
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), // Custom text style
      ),
    );
  }

  // Function to build confirm button
  Widget _buildConfirmButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _buildElevatedButton('Confirm', Colors.blue, _confirmSeats), // Confirm button
    );
  }
}
