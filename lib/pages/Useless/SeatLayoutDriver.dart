import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SeatLayoutPage extends StatefulWidget {
  final String? docID;

  SeatLayoutPage({Key? key, this.docID}) : super(key: key);

  @override
  _SeatLayoutPageState createState() => _SeatLayoutPageState();
}

class _SeatLayoutPageState extends State<SeatLayoutPage> {
  List<List<Map<String, dynamic>>> _seatLayout = [];
  int _rows = 0;
  int _cols = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchSeatData();
  }

  Future<void> _fetchSeatData() async {
    try {
      // Fetch the bus seatData using the docID from the registration collection
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('registration')
          .doc(widget.docID)
          .get();

      if (doc.exists) {
        Map<String, dynamic> data = doc.data()! as Map<String, dynamic>;

        // Ensure that 'seatData' exists and has the correct structure
        if (data.containsKey('seatData') && data['seatData'] != null) {
          Map<String, dynamic> seatData =
              data['seatData'] as Map<String, dynamic>;

          // Extract rows, columns, and seat layout
          _rows = seatData['rows'] as int? ?? 0;
          _cols = _calculateColumns(seatData['selectedModel'] as String?);

          List<Map<String, dynamic>> flatSeatLayout =
              List<Map<String, dynamic>>.from(seatData['seatLayout'] ?? []);

          // Rebuild seat layout
          setState(() {
            _seatLayout = rebuildSeatLayout(flatSeatLayout, _rows, _cols);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      print('Error fetching seat data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  int _calculateColumns(String? model) {
    // Define how many columns based on the selected bus model (adjust logic accordingly)
    // Example logic; adjust based on your needs
    if (model == 'modelX') {
      return 4; // Example value
    }
    // Default value
    return 4;
  }

  List<List<Map<String, dynamic>>> rebuildSeatLayout(
      List<Map<String, dynamic>> flatList, int rows, int cols) {
    List<List<Map<String, dynamic>>> seatLayout =
        List.generate(rows, (_) => List.generate(cols, (_) => {}));

    for (var seat in flatList) {
      int row = seat['row'] as int? ?? 0;
      int col = seat['col'] as int? ?? 0;
      seatLayout[row][col] = {
        'status': seat['status'] as String? ?? 'empty',
      };
    }

    return seatLayout;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seat Layout'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildSeatLayout(),
    );
  }

  Widget _buildSeatLayout() {
    if (_seatLayout.isEmpty) {
      return Center(child: Text('No seat layout available.'));
    }

    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _cols,
      ),
      itemCount: _rows * _cols,
      itemBuilder: (context, index) {
        int row = index ~/ _cols;
        int col = index % _cols;
        Map<String, dynamic> seat = _seatLayout[row][col];

        return Container(
          margin: EdgeInsets.all(4.0),
          color: seat['status'] == 'occupied' ? Colors.red : Colors.green,
          child: Center(
            child: Text(
              seat['status'] ?? 'Empty',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      },
    );
  }
}
