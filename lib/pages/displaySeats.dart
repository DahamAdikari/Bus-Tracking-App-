import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class DisplaySeats extends StatefulWidget {
  final String docID; // Document ID passed from AdminPage

  DisplaySeats({required this.docID});

  @override
  _DisplaySeatsState createState() => _DisplaySeatsState();
}

class _DisplaySeatsState extends State<DisplaySeats> {
  Map<String, dynamic>? seatData; // Seat data to be fetched from Firebase
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
      print("Fetching document with ID: ${widget.docID}");
      
      // Fetch the seat data from the Firebase document
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('registration')
          .doc(widget.docID)
          .get();

      if (doc.exists && doc.data() != null) {
        var data = doc.data() as Map<String, dynamic>;
        print("Document data: $data");
        
        setState(() {
          seatData = data['seatData'] ?? {}; // Ensure seatData is not null
          _isLoading = false; // Data fetched, stop loading
          _setLayoutBasedOnModel(); // Call the function to adjust the layout based on the model
        });
      } else {
        print("Document does not exist or has no data.");
      }
    } catch (e) {
      print('Error fetching seat data: $e');
    }
  }

  // Function to set layout based on seat model (stored as a number in Firebase)
  void _setLayoutBasedOnModel() {
    int seatModel = seatData!['selectedModel']; // Fetch seat model as a number (e.g., 1, 2, 3)

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

  // Function to update seat status in Firebase
  Future<void> _updateSeatStatus(String newStatus) async {
    List<dynamic> updatedSeatLayout = List.from(seatData!['seatLayout']);

    // Loop through selected seats and update their status
    for (int index in _selectedSeats) {
      updatedSeatLayout[index]['status'] = newStatus;
    }

    try {
      // Update Firestore with the new seat layout
      await FirebaseFirestore.instance
          .collection('registration')
          .doc(widget.docID)
          .update({
        'seatData.seatLayout': updatedSeatLayout,
      });

      setState(() {
        seatData!['seatLayout'] = updatedSeatLayout; // Update local data
        _selectedSeats.clear(); // Clear selection after update
      });
    } catch (e) {
      print('Error updating seat status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Layout'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Loading spinner
          : Column(
              children: [
                Expanded(child: _buildSeatLayout()), // Build seat layout
                _buildAdminControls(), // Add seat control buttons
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
                'Row: ${seat['row']}, Col: ${seat['col']}', // Display seat coordinates
                textAlign: TextAlign.center,
              ),
            ),
          ),
        );
      },
    );
  }

  // Function to build admin control buttons
  Widget _buildAdminControls() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          ElevatedButton(
            onPressed: () {
              _updateSeatStatus('available'); // Change selected seats to available (green)
            },
            child: Text('Add Seats'),
          ),
          ElevatedButton(
            onPressed: () {
              _updateSeatStatus('empty'); // Change selected seats to empty (red)
            },
            child: Text('Delete Seats'),
          ),
        ],
      ),
    );
  }
}
