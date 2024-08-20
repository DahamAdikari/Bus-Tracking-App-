import 'package:flutter/material.dart';
import 'package:test_4/auth/constants/sizes.dart';
import 'model_on_boarding.dart';

class OnBoardingPageWidgets extends StatelessWidget {
  const OnBoardingPageWidgets({
    super.key,
    required this.model,
  });
  final OnBoardingModel model;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      padding: EdgeInsets.all(tDefaultSize),
      color: model.bgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Image(
            image: AssetImage(model.image),
            height: size.height * 0.35,
          ), //50% of screen
          Column(
            children: [
              Text(
                model.title,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                ), // Set font size for tAppName
              ),
              SizedBox(
                height: 8.0,
              ),
              Text(
                model.SubTitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500), // Set font size for tAppName
              ),
            ],
          ),

          Text(model.CounterText,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 1, fontWeight: FontWeight.w800)),
        ],
      ),
    );
  }
}
