import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_4/services/stripe_service.dart';
import 'package:test_4/ticket_screen.dart';

class SeatBooking extends StatefulWidget {
  final String busId;
  final String driverId;

  SeatBooking({required this.busId, required this.driverId});

  @override
  _SeatBookingState createState() => _SeatBookingState();
}

class _SeatBookingState extends State<SeatBooking> {
  Map<String, dynamic>? seatData, source, destination;
  bool _isLoading = true; // For tracking data loading
  int _crossAxisCount = 4; // Default seat layout columns
  double _crossAxisSpacing = 10.0; // Default cross-axis spacing
  double _mainAxisSpacing = 10.0; // Default main-axis spacing
  List<int> _selectedSeats = []; // Track selected seats by their index
  List<Map<String, dynamic>> _selectedSeatInfo =
      []; // Track selected seats' row and column info

  bool _paymentSuccess = false; // Track payment success

  @override
  void initState() {
    super.initState();
    _fetchSeatData(); // Fetch seat data on initialization
  }

  // Fetch seat data from Firestore
  Future<void> _fetchSeatData() async {
    try {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('driver')
          .doc(widget.driverId)
          .collection('buses')
          .doc(widget.busId)
          .get();

      if (doc.exists && doc.data() != null) {
        var data = doc.data() as Map<String, dynamic>;
        setState(() {
          seatData = data['seatData']; // Ensure seat data is not null
          source = {'locationName': data['sourceLocation']}; // Add source
          destination = {'locationName': data['destinationLocation']}; // Add destination
          _setLayoutBasedOnModel(); // Adjust seat layout based on model
          _isLoading = false; // Stop loading after data is fetched
        });
      } else {
        print("Bus document does not exist or has no seat data.");
      }
    } catch (e) {
      print('Error fetching seat data: $e');
    }
  }

  // Set layout based on the seat model from the Firestore document
  void _setLayoutBasedOnModel() {
    int seatModel = seatData!['selectedModel']; // Get seat model

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

  // Toggle seat selection
  void _toggleSeatSelection(int index) {

    var seat = seatData!['seatLayout'][index]; // Get seat data at the index
    String status = seat['status'] ?? 'unknown'; // Get seat status (available, booked, etc.)

    // Check if seat is available before allowing selection
    if (status == 'available') {
      setState(() {
        if (_selectedSeats.contains(index)) {
          _selectedSeats.remove(index); // Deselect if already selected
          _selectedSeatInfo.removeWhere((seatInfo) =>
          seatInfo['row'] == seat['row'] && seatInfo['col'] == seat['col']); // Remove from selected info
        } else {
          _selectedSeats.add(index); // Select seat
          _selectedSeatInfo.add({
          'row': seat['row'],
          'col': seat['col'],
        }); // Add seat info
        }
      });
    } else {
      // Show snackbar message when seat is not available
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Seat is not available.'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        ),
      );
    }

  }

  // Build seat layout grid
  Widget _buildSeatLayout() {
    List<dynamic> seatLayout = seatData!['seatLayout']; // Get seat layout

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount, // Set columns dynamically
        crossAxisSpacing: _crossAxisSpacing, // Dynamic cross-axis spacing
        mainAxisSpacing: _mainAxisSpacing, // Dynamic main-axis spacing
      ),
      itemCount: seatLayout.length, // Number of seats
      itemBuilder: (context, index) {
        var seat = seatLayout[index];
        String status = seat['status'] ??
            'unknown'; // Seat status (available, booked, etc.)
        bool isSelected = _selectedSeats.contains(index); // Check if selected

        // Set seat color based on status
        Color seatColor;
        if (isSelected) {
          seatColor = Colors.blue; // Highlight selected seats in blue
        } else {
          if (status == 'available') {
            seatColor = Colors.green; // Available seats are green
          } else if (status == 'booked') {
            seatColor = Colors.red; // Booked seats are red
          } else {
            seatColor = Color.fromARGB(106, 180, 175, 175); // Empty/unknown seats are grey
          }
        }

        return GestureDetector(
          onTap: () => _toggleSeatSelection(index), // Toggle seat selection
          child: Container(
            decoration: BoxDecoration(
              color: seatColor, // Seat color based on status
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected ? Colors.yellow : Colors.transparent,
                width: 2,
              ),
            ),
            child: Center(

              child: Text('Row: ${seat['row']}, Col: ${seat['col']}', textAlign: TextAlign.center), // Display seat info

            ),
          ),
        );
      },
    );
  }

/*
Widget _buildBookButton() {
  return ElevatedButton(
    onPressed: () {
      int seatCount = _selectedSeats.length;
      if (seatCount > 0) {
        // Start the payment process
        StripeService.instance.makePayment(
            seatCount, widget.busId, _selectedSeats, widget.driverId)
          .then((_) {
            // If payment was successful, update payment status
            setState(() {
              _paymentSuccess = true; // Update payment status after success
            });
          }).catchError((e) {
            // If there was an error, ensure payment success is false
            setState(() {
              _paymentSuccess = false;
            });
            print("Payment failed: $e");
          });
      } else {
        print("No seats selected.");
      }
    },
    child: Text('Book Selected Seats'),
  );
}*/

Widget _buildBookButton() {
  return ElevatedButton(
    onPressed: () {
      int seatCount = _selectedSeats.length;
      if (seatCount > 0) {
        // Start the payment process
        StripeService.instance.makePayment(
            seatCount, widget.busId, _selectedSeats, widget.driverId)
          .then((paymentSuccess) {
            if (paymentSuccess) {
              // If payment was successful, update payment status
              setState(() {
                _paymentSuccess = true; // Show "Show Tickets" button
              });
            } else {
              setState(() {
                _paymentSuccess = false; // Ensure the button doesn't show
              });
              print("Payment failed.");
            }
          }).catchError((e) {
            setState(() {
              _paymentSuccess = false; // Ensure payment failure case
            });
            print("Payment failed: $e");
          });
      } else {
        print("No seats selected.");
      }
    },
    child: Text('Book Selected Seats'),
  );
}


/*

  Widget _buildShowTicketsButton() {
  return ElevatedButton(
    onPressed: () {
      if (_paymentSuccess) { // Show tickets only if payment was successful
        int seatCount = _selectedSeats.length;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketScreen(
              seatCount: seatCount,
              sourceLocation: source?['locationName'] ?? 'Unknown',
              destinationLocation: destination?['locationName'] ?? 'Unknown',
              selectedSeats: _selectedSeatInfo,
            ),
          ),
        );
        print("Show Tickets pressed");
      } else {
        print("Payment was not successful, cannot show tickets.");
      }
    },
    child: Text('Show Tickets'),
  );
}*/



Widget _buildShowTicketsButton() {
  return ElevatedButton(
    onPressed: () {
      if (_paymentSuccess) { // Show tickets only if payment was successful
        int seatCount = _selectedSeats.length;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => TicketScreen(
              seatCount: seatCount,
              sourceLocation: source?['locationName'] ?? 'Unknown',
              destinationLocation: destination?['locationName'] ?? 'Unknown',
              selectedSeats: _selectedSeatInfo,
            ),
          ),
        );
        print("Show Tickets pressed");
      } else {
        print("Payment was not successful, cannot show tickets.");
      }
    },
    child: Text('Show Tickets'),
  );
}




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Booking'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading indicator
          : Column(
              children: [
                Expanded(child: _buildSeatLayout()), // Show seat layout
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _buildBookButton(), // Show booking button
                ),
                if (_paymentSuccess)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child:
                        _buildShowTicketsButton(), // Show tickets button after payment
                  ),
              ],
            ),
    );
  }
}
