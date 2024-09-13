import 'package:flutter/material.dart';

class RegSeats extends StatelessWidget {
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
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
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
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
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
                  },
                  child: Container(
                    padding: EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
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
            Text('Enter number of rows:'),
            TextField(),
            SizedBox(height: 10),
            Text('Enter number of columns:'),
            TextField(),
            SizedBox(height: 10),
            Text('Enter number of seats:'),
            TextField(),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                },
                child: Text('Check'),
              ),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Return to the previous screen
                },
                child: Text('Confirm seats order'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class RegSeats extends StatefulWidget {
//   final String busID; // Bus ID to link seats to a bus document
//   final String busName;
  
//   RegSeats({required this.busID, required this.busName});

//   @override
//   _RegSeatsState createState() => _RegSeatsState();
// }

// class _RegSeatsState extends State<RegSeats> {
//   int rows = 0;
//   int columns = 0;
//   List<List<String>> seatLayout = [];
//   String selectedModel = '1x2';

//   void _generateSeatLayout() {
//     seatLayout = List.generate(rows, (r) {
//       return List.generate(columns, (c) => 'Available');
//     });
//   }

//   void _saveSeatLayout() async {
//     await FirebaseFirestore.instance.collection('buses').doc(widget.busID).set({
//       'busName': widget.busName,
//       'busID': widget.busID,
//       'seatLayout': seatLayout,
//       'blockedSeats': [], // Placeholder for blocked seats
//       'bookedSeats': [], // Placeholder for booked seats
//     });
    
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text('Seats added successfully')),
//     );

//     Navigator.pop(context); // Navigate back after saving
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Add Seats for Bus ${widget.busName}'),
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text('Select bus model:'),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: [
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedModel = '1x2';
//                     });
//                   },
//                   child: _buildModelOption('1x2', 'assets/images/seat_booking_images/model_1x2.png'),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedModel = '2x2';
//                     });
//                   },
//                   child: _buildModelOption('2x2', 'assets/images/seat_booking_images/model_2x2.png'),
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     setState(() {
//                       selectedModel = '2x3';
//                     });
//                   },
//                   child: _buildModelOption('2x3', 'assets/images/seat_booking_images/model_2x3.png'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 20),
//             Text('Enter number of rows:'),
//             TextField(
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 rows = int.tryParse(value) ?? 0;
//               },
//             ),
//             SizedBox(height: 10),
//             Text('Enter number of columns:'),
//             TextField(
//               keyboardType: TextInputType.number,
//               onChanged: (value) {
//                 columns = int.tryParse(value) ?? 0;
//               },
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () {
//                 setState(() {
//                   _generateSeatLayout();
//                 });
//               },
//               child: Text('Generate Seat Layout'),
//             ),
//             SizedBox(height: 20),
//             _buildSeatLayoutPreview(),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton(
//                 onPressed: _saveSeatLayout,
//                 child: Text('Confirm seats and save'),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildModelOption(String model, String imagePath) {
//     return Container(
//       padding: EdgeInsets.all(8.0),
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.circular(8.0),
//         border: Border.all(color: selectedModel == model ? Colors.blue : Colors.grey),
//       ),
//       child: Column(
//         children: [
//           Image.asset(
//             imagePath,
//             width: 100,
//             height: 100,
//           ),
//           Text(model),
//         ],
//       ),
//     );
//   }

//   Widget _buildSeatLayoutPreview() {
//     if (rows == 0 || columns == 0) {
//       return Text('No layout generated yet. Please enter rows and columns.');
//     }
//     return Column(
//       children: List.generate(rows, (r) {
//         return Row(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           children: List.generate(columns, (c) {
//             return Container(
//               margin: EdgeInsets.all(4.0),
//               padding: EdgeInsets.all(8.0),
//               color: seatLayout[r][c] == 'Available' ? Colors.green : Colors.red,
//               child: Text(
//                 '${r + 1}${String.fromCharCode(65 + c)}', // Seat label like 1A, 1B, etc.
//                 style: TextStyle(color: Colors.white),
//               ),
//             );
//           }),
//         );
//       }),
//     );
//   }
// }
