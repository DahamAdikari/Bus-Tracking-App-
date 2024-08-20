import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_4/auth/sign_in.dart';
import '../constants/colors.dart';
import '../constants/image_strings.dart';
import '../constants/sizes.dart';
import '../constants/text_strings.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(tDefaultSize),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  WelcomeTittle,
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  WelcomeSubTittle,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const Image(
              image: AssetImage(PassengerImage),
              height: 200, // Set the desired height
              fit: BoxFit.contain,
            ),
            ElevatedButton(
              onPressed: () {
                String chosen_role = 'Passenger'; // Store the selected role
                Get.to(() => SignInScreen(
                    role: chosen_role)); // Pass the role to the SignInScreen
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: tPrimaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text("I am Passenger"),
            ),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(height: 2, width: 130, color: Colors.grey),
                  SizedBox(width: 10),
                  Text("or"),
                  SizedBox(width: 10),
                  Container(height: 2, width: 130, color: Colors.grey),
                ],
              ),
            ),
            const Image(
              image: AssetImage(DriverImage),
              height: 200, // Set the desired height
              fit: BoxFit.contain,
            ),
            ElevatedButton(
              onPressed: () {
                String chosen_role = 'Driver'; // Store the selected role
                Get.to(() => SignInScreen(
                    role: chosen_role)); // Pass the role to the SignInScreen
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: tPrimaryColor,
                foregroundColor: Colors.white,
              ),
              child: Text("I am Driver"),
            ),
          ],
        ),
      ),
    );
  }
}
