import 'package:flutter/material.dart';
import 'package:test_4/auth/constants/sizes.dart';
import 'model_on_boarding.dart';

// class OnBoardingPageWidgets extends StatelessWidget {
//   const OnBoardingPageWidgets({
//     super.key,
//     required this.model,
//   });
//   final OnBoardingModel model;
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Container(
//       padding: EdgeInsets.all(tDefaultSize),
//       color: model.bgColor,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: [
//           Image(
//             image: AssetImage(model.image),
//             height: size.height * 0.35,
//           ), //50% of screen
//           Column(
//             children: [
//               Text(
//                 model.title,
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.w700,
//                 ), // Set font size for tAppName
//               ),
//               SizedBox(
//                 height: 8.0,
//               ),
//               Text(
//                 model.SubTitle,
//                 textAlign: TextAlign.center,
//                 style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: FontWeight.w500), // Set font size for tAppName
//               ),
//             ],
//           ),
//
//           Text(model.CounterText,
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 1, fontWeight: FontWeight.w800)),
//         ],
//       ),
//     );
//   }
// }
class OnBoardingPageWidgets extends StatelessWidget {
  const OnBoardingPageWidgets({
    super.key,
    required this.model,
  });

  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; // Get screen size

    return Container(
      padding: EdgeInsets.all(size.width * 0.05), // Padding relative to screen size
      color: model.bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // Image section with height responsive to screen size
          Image(
            image: AssetImage(model.image),
            height: size.height * 0.35, // 35% of screen height
          ),
          Column(
            children: [
              // Title with responsive font size
              Text(
                model.title,
                style: TextStyle(
                  fontSize: size.width * 0.06, // 6% of screen width
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(
                height: size.height * 0.02, // Spacing relative to screen height
              ),
              // Subtitle with responsive font size
              Text(
                model.SubTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: size.width * 0.04, // 4% of screen width
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          // Counter Text with responsive font size
          Text(
            model.CounterText,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: size.width * 0.04, // 4% of screen width
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}