import 'package:flutter/material.dart';

class RegSeats extends StatefulWidget {
  @override
  _RegSeatsState createState() => _RegSeatsState();
}

class _RegSeatsState extends State<RegSeats> {
  int selectedModel = 0;
  int seatCount = 0;
  int rows = 0;

  // Using List<List<Map<String, dynamic>>> to represent the seat layout.
  List<List<Map<String, dynamic>>> seatLayout = [];

  // Function to create seat layout
  void createSeatLayout() {
    if (rows <= 0 || seatCount <= 0) {
      seatLayout.clear();
      setState(() {});
      return;
    }

    seatLayout.clear();
    int columns = 0;

    // Determine columns based on the bus model selected
    switch (selectedModel) {
      case 1:
        columns = 4; // 1x2 model
        break;
      case 2:
        columns = 5; // 2x2 model
        break;
      case 3:
        columns = 6; // 2x3 model
        break;
    }

    int remainingSeats = seatCount;

    for (int row = 0; row < rows; row++) {
      List<Map<String, dynamic>> currentRow = [];

      // For the last row, just mark all as available
      if (row == rows - 1) {
        for (int col = 0; col < columns; col++) {
          if (remainingSeats > 0) {
            currentRow.add({'row': row, 'col': col, 'status': 'available'});
            remainingSeats--;
          } else {
            currentRow.add({'row': row, 'col': col, 'status': 'Empty'});
          }
        }
      } else {
        for (int col = 0; col < columns; col++) {
          if (remainingSeats > 0) {
            if ((selectedModel == 1 && col == 1) ||
                (selectedModel == 2 && col == 2) ||
                (selectedModel == 3 && col == 2)) {
              currentRow
                  .add({'row': row, 'col': col, 'status': 'Empty'}); // Space
            } else {
              currentRow
                  .add({'row': row, 'col': col, 'status': 'available'}); // Seat
              remainingSeats--;
            }
          } else {
            currentRow.add({
              'row': row,
              'col': col,
              'status': 'Empty'
            }); // No more seats, just empty
          }
        }
      }

      seatLayout.add(currentRow);
    }

    setState(() {}); // Refresh the UI
  }

  // Function to build the seat layout
  Widget buildSeatLayout() {
    if (seatLayout.isEmpty || rows <= 0 || seatCount <= 0) {
      return Center(
        child: Text(
          'Please enter valid number of rows and seats.',
          style: TextStyle(color: Colors.red),
        ),
      );
    }

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
        crossAxisCount:
            seatLayout[0].length, // Set column count based on layout
        childAspectRatio: seatWidth / seatHeight,
      ),
      itemCount: rows * seatLayout[0].length, // Total number of items
      itemBuilder: (context, index) {
        int rowIndex = index ~/ seatLayout[0].length;
        int colIndex = index % seatLayout[0].length;
        bool isEmpty = seatLayout[rowIndex][colIndex]['status'] == "Empty";
        bool isBooked = seatLayout[rowIndex][colIndex]['status'] == "booked";

        return Padding(
          padding: const EdgeInsets.all(4.0),
          child: Container(
            width: seatWidth,
            height: seatHeight,
            decoration: BoxDecoration(
              color: isEmpty
                  ? Colors.transparent
                  : (isBooked ? Colors.red : Colors.orange),
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
        backgroundColor: Color(0xFF000080),
        title: Text('Add Seats',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
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
                buildModelOption('1 x 2', 1),
                buildModelOption('2 x 2', 2),
                buildModelOption('2 x 3', 3),
              ],
            ),
            SizedBox(height: 20),
            Text('Enter number of seats:'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  seatCount = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            Text('Enter number of rows:'),
            TextField(
              keyboardType: TextInputType.number,
              onChanged: (value) {
                setState(() {
                  rows = int.tryParse(value) ?? 0;
                });
              },
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: createSeatLayout,
                //child: Text('Check Seat Layout'),
                child: Text(
                  'Check Seat Layout',
                    style: TextStyle(
                      fontSize: 16, // Font size
                      fontWeight: FontWeight.bold, // Font weight
                      color: Colors.blue.shade900, // Text color
                    ),
                  ),
                style: ElevatedButton.styleFrom(
                  fixedSize: Size(300, 40),
                ),
              ),
            ),
            SizedBox(height: 20),
            buildSeatLayout(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Pass data back to AddBusPage when confirming the layout
                  Navigator.pop(context, {
                    'selectedModel': selectedModel,
                    'rows': rows,
                    'seatCount': seatCount,
                    'seatLayout': seatLayout,
                  });
                },
                child: Text(
                    'Confirm seats order',
                      style: TextStyle(
                        fontSize: 16, // Font size
                        fontWeight: FontWeight.bold, // Font weight
                        color: Colors.white, // Text color
                      ),
                    ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(300, 40),
                    backgroundColor: Colors.blue.shade900,
                  ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper to build the bus model selection widget
  GestureDetector buildModelOption(String label, int model) {
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedModel = model;
        });
      },
      child: Container(
        padding: EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: selectedModel == model ? Colors.blue : Colors.grey[200],
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: Column(
          children: [
            Image.asset(
              'assets/images/seat_booking_images/model_$model.png',
              width: 100,
              height: 100,
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}
