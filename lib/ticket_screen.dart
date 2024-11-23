import 'package:flutter/material.dart';
import 'package:test_4/pages/passenger/seat_booking.dart';

class TicketScreen extends StatelessWidget {
  final int seatCount; // Add seat count parameter

  //const TicketScreen({super.key});
  const TicketScreen({super.key, required this.seatCount}); // Update constructor
  static List<Color> colors = [
   // const Color.fromARGB(255, 7, 0, 0),
    Colors.black,
    Colors.black,
    Colors.black,
    Colors.black,
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 170, 217, 241),
      appBar: AppBar(
        backgroundColor: Colors.indigo.shade600,
        title: const Text(
          'E-Tickets',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: ListView.separated(
          padding: const EdgeInsets.all(15),
          itemBuilder: (context, index) {
            return Container(
              color: Colors.red,
              height: MediaQuery.of(context).size.height * 0.26,
              width: double.infinity,
              child: Stack(children: [
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        color: colors[index % colors.length],
                        child: Center(
                            child: RotatedBox(
                          quarterTurns: 3,
                          child: Text(
                            'Bus Ticket #${index + 1}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        )),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Container(
                        color: Colors.white,
                        padding: const EdgeInsets.all(10),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bus Ticket #${index + 1}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Expanded(
                                child: Row(children: [
                                  SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    child: Column(children: [
                                      Expanded(
                                        flex: 2,
                                        child: Material(
                                          elevation: 2,
                                          child: Container(
                                            color: Colors.grey.shade200,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(
                                        height: 2,
                                      ),
                                      Image.asset('assets/images/bar_code.jpg')
                                    ]),
                                  ),
                                  const SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                    child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          const Row(
                                            children: [
                                              Icon(Icons.calendar_today),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  '00 month 2024 00:00',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const Row(
                                            children: [
                                              Icon(Icons.location_on_outlined),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'From',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const Row(
                                            children: [
                                              Icon(Icons.location_on_outlined),
                                              SizedBox(
                                                width: 5,
                                              ),
                                              Expanded(
                                                child: Text(
                                                  'To',
                                                  style: TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          ElevatedButton.icon(
                                              onPressed: () {},
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.white,
                                                  shape: const StadiumBorder(
                                                    side: BorderSide(
                                                        width: 1,
                                                        color: Colors.blue),
                                                  )),
                                              icon: const Icon(
                                                  Icons.check_circle),
                                              label: Text(
                                                'Rs. 100'.toUpperCase(),
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                ),
                                              ))
                                        ]),
                                  ),
                                ]),
                              ),
                            ]),
                      ),
                    ),
                  ],
                ),
                CustomPaint(
                  painter: SideCutsDesign(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                  ),
                ),
                CustomPaint(
                  painter: DottedInitialPath(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                  ),
                ),
                CustomPaint(
                  painter: DottedMiddlePath(),
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * 0.25,
                    width: double.infinity,
                  ),
                ),
              ]),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(
                height: 15,
              ),
          itemCount: seatCount, // Use seatCount here instead of fixed length    
          //colors.length
          ),
    );
  }
}

class DottedMiddlePath extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3;
    double dashSpace = 4;
    double startY = 10;
    final paint = Paint()
      ..color = const Color.fromARGB(255, 170, 217, 241)
      ..strokeWidth = 1;

    while (startY < size.height - 10) {
      canvas.drawCircle(Offset(size.width / 5, startY), 2, paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class DottedInitialPath extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 3;
    double dashSpace = 4;
    double startY = 10;
    final paint = Paint()
      ..color = const Color.fromARGB(255, 170, 217, 241)
      ..strokeWidth = 1;

    while (startY < size.height - 10) {
      canvas.drawCircle(Offset(0, startY), 2, paint);
      startY += dashWidth + dashSpace;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class SideCutsDesign extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var h = size.height;
    var w = size.width;

    canvas.drawArc(
        Rect.fromCircle(center: Offset(0, h / 2), radius: 18),
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(255, 170, 217, 241));
    canvas.drawArc(
        Rect.fromCircle(center: Offset(w, h / 2), radius: 18),
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(255, 170, 217, 241));
    canvas.drawArc(
        Rect.fromCircle(center: Offset(w / 5, h), radius: 7),
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(255, 170, 217, 241));
    canvas.drawArc(
        Rect.fromCircle(center: Offset(w / 5, 0), radius: 7),
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(255, 170, 217, 241));
    canvas.drawArc(
        Rect.fromCircle(center: Offset(0, h), radius: 7),
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(255, 170, 217, 241));
    canvas.drawArc(
        Rect.fromCircle(center: const Offset(0, 0), radius: 7),
        0,
        10,
        false,
        Paint()
          ..style = PaintingStyle.fill
          ..color = const Color.fromARGB(255, 170, 217, 241));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}