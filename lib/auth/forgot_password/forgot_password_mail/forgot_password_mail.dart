import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constants/colors.dart';
import '../../constants/image_strings.dart';
import '../../constants/sizes.dart';
import '../forgot_password_otp/otp.dart';

class ForgetPasswordMailScreen extends StatelessWidget {
  const ForgetPasswordMailScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery
        .of(context)
        .size;
    return SafeArea(
      child: Scaffold(
        backgroundColor:bOnBoardingColor3,
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height:tDefaultSize*4,),
                Image(image:AssetImage(ForgetPasswordImage),height: size.height * 0.3),
                SizedBox(height: 30.0,),
                Text("Forget Password",style: TextStyle(fontSize:24,fontWeight: FontWeight.w900),),
                Text("Select one of the option given below to rest your password",style: TextStyle(fontSize:14,fontWeight: FontWeight.w500,),textAlign: TextAlign.center,),

                SizedBox(height:30,),
                Form(child: Column(children: [

                  TextFormField(
                    decoration: const InputDecoration(
                      label: Text("E-Mail"),hintText: "Enter Your Email",
                      prefixIcon: Icon(Icons.email_outlined),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  SizedBox(height: 20.0,),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(()=>const OtpScreen());
                      },
                      style: OutlinedButton.styleFrom(
                          shape: RoundedRectangleBorder(),
                          backgroundColor: tPrimaryColor,
                          foregroundColor: Colors.white,
                          side: BorderSide(
                              color: Colors.black87, width: 2),
                          padding: EdgeInsets.symmetric(
                              vertical: 8, horizontal: 50)),
                      child: Text("Next"),
                    ),
                  ),

                ],))

              ],
            ),
          ),
        ),

      ),
    );
  }
}
