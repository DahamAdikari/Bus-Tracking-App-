import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:test_4/auth/log_in.dart';
import 'package:test_4/auth/sign_in.dart';

import '../Common_Classes/login_or_signin_common.dart';
//import '../LogIn_SignIn_Common/login_or_signin_common.dart';
import '../constants/colors.dart';
import '../constants/image_strings.dart';

class PassengerSelect extends StatelessWidget {
  const PassengerSelect({super.key});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: bOnBoardingColor3,
      body: LogOrSign(
        tittle1: "SIGNIN",
        tittle2: "LOGIN",
        tittle3: "Hello Passenger",
        userImagePath: PassengerImage,
        onTap1: () {
          Get.to(() => const SignInScreen());
        },
        onTap2: () {
          Get.to(() => const LogInScreen());
        },
      ),
    );
  }
}
