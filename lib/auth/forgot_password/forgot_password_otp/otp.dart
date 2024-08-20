import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';

import '../../constants/colors.dart';
import '../../constants/sizes.dart';

class OtpScreen extends StatelessWidget {
  const OtpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery
        .of(context)
        .size;
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(

          mainAxisAlignment:MainAxisAlignment.center,

          children: [
            Text("CO\nDE",style:TextStyle(fontSize:80,fontWeight: FontWeight.bold,),),
            Text("VERIFICATION",style:TextStyle(fontSize:16,fontWeight: FontWeight.w700),),
            SizedBox(height: 8,),
            Text("Enter the verification code send at abc@gmail.com ",style:TextStyle(fontSize: 16,fontWeight:FontWeight.w500),
              textAlign: TextAlign.center,),
            const SizedBox(height: 20.0,),
            OtpTextField(
              numberOfFields: 6,
              fillColor:bOnBoardingColor3,
              filled: true,
              onSubmit: (code){print("OTP is => $code");},
              keyboardType: TextInputType.number,
              borderColor:tPrimaryColor,
            ),
            SizedBox(height: 20.0,),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
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

          ],
        ),
      ),
    );
  }
}
