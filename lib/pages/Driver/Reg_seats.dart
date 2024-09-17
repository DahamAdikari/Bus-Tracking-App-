
import 'package:flutter/material.dart';

class RegSeats extends StatefulWidget {
  @override
  _RegSeatsState createState() => _RegSeatsState();
}

class _RegSeatsState extends State<RegSeats> {
  // State variables
  int selectedModel = 0;
  int seatCount = 0;
  int rows = 0; // Number of rows
  List<List<String>> seatLayout = [];

  // Function to create seat layout based on input rows, columns, and seat count
  void createSeatLayout() {
    if (rows <= 0 || seatCount <= 0) {
      // Don't generate layout if rows or seat count are invalid
      seatLayout.clear();
      setState(() {}); // Refresh the UI
      return;
    }

    // Clear previous layout
    seatLayout.clear();

    int columns = 0;
    switch (selectedModel) {
      case 1: // 1x2 model: 1 seat, 1 space, 2 seats
        columns = 4; // 1 seat + 1 space + 2 seats
        break;
      case 2: // 2x2 model: 2 seats, 1 space, 2 seats
        columns = 5; // 2 seats + 1 space + 2 seats
        break;
      case 3: // 2x3 model: 2 seats, 1 space, 3 seats
        columns = 6; // 2 seats + 1 space + 3 seats
        break;
    }

    int remainingSeats = seatCount;

    // Generate seat layout
    for (int row = 0; row < rows; row++) {
      List<String> currentRow = [];
      for (int col = 0; col < columns; col++) {
        if (remainingSeats > 0) {
          // Add seats and spaces based on the selected model
          if ((selectedModel == 1 && col == 1) || (selectedModel == 2 && col == 2) || (selectedModel == 3 && col == 2)) {
            currentRow.add("Empty"); // Add space based on the model
          } else {
            currentRow.add("Seat");
            remainingSeats--;
          }
        } else {
          currentRow.add("Empty");
        }
      }

      // Fill the last row with all seats, ignoring spaces
      if (row == rows - 1 && remainingSeats > 0) {
        for (int col = 0; col < columns && remainingSeats > 0; col++) {
          if (currentRow[col] == "Empty") {
            currentRow[col] = "Seat";
            remainingSeats--;
          }
        }
      }

      seatLayout.add(currentRow);
    }

    setState(() {}); // Refresh the UI
  }

  // Function to build the seat layout grid view
  Widget buildSeatLayout() {
    if (seatLayout.isEmpty || rows <= 0 || seatCount <= 0) {
      // If rows or seat count are invalid, show an error message
      return Center(
        child: Text(
          'Please enter valid number of rows and seats.',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

    // Adjust seat sizes based on the bus model
    double seatWidth = 40;
    double seatHeight = 40;

    switch (selectedModel) {
      case 1:
        seatWidth = 60; // Wider seats for 1x2 model
        break;
      case 2:
        seatWidth = 50; // Medium width for 2x2 model
        break;
      case 3:
        seatWidth = 40; // Narrower width for 2x3 model
        break;
      default:
        seatWidth = 40; // Default seat size
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: seatLayout[0].length, // Set column count based on layout
        childAspectRatio: seatWidth / seatHeight,
      ),
      itemCount: rows * seatLayout[0].length, // Total number of items
      itemBuilder: (context, index) {
        int rowIndex = index ~/ seatLayout[0].length;
        int colIndex = index % seatLayout[0].length;
        bool isEmpty = seatLayout[rowIndex][colIndex] == "Empty";

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: seatWidth,
            height: seatHeight,
            decoration: BoxDecoration(
              color: isEmpty ? Colors.transparent : Colors.orange,
              border: Border.all(color: Colors.black),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Seats'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select bus model:'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedModel = 1; // Select 1x2 model
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: selectedModel == 1 ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/seat_booking_images/model_1x2.png',
                          width: 100,
                          height: 100,
                        ),
                        Text('1 x 2'),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedModel = 2; // Select 2x2 model
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: selectedModel == 2 ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/seat_booking_images/model_2x2.png',
                          width: 100,
                          height: 100,
                        ),
                        Text('2 x 2'),
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedModel = 3; // Select 2x3 model
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: selectedModel == 3 ? Colors.blue : Colors.grey[200],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      children: [
                        Image.asset(
                          'assets/images/seat_booking_images/model_2x3.png',
                          width: 100,
                          height: 100,
                        ),
                        Text('2 x 3'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Enter number of seats:'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  seatCount = int.tryParse(value) ?? 0; // Update seat count
                });
              },
            ),
            SizedBox(height: 20),
            Text('Enter number of rows:'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  rows = int.tryParse(value) ?? 0; // Update row count
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                createSeatLayout(); // Generate seat layout
              },
              child: Text('Check Seat Layout'),
            ),
            SizedBox(height: 20),
            // Display the seat layout
            buildSeatLayout(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle seat confirmation logic, e.g., save to Firebase
                Navigator.pop(context); // Return to the previous screen
              },
              child: Text('Confirm seats order'),
            ),
          ],
        ),
      ),
    );
  }
}

