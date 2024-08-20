import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../constants/sizes.dart';
import '../forgot_password_mail/forgot_password_mail.dart';
import '../forgot_password_phone/forgot_password_phone.dart';
import 'forgot_password_btn_widget.dart';

class ForgetPasswordScreen{

  static void BuildShowModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(tDefaultSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Make selection",style: TextStyle(fontSize:24,fontWeight: FontWeight.w900),),
            Text("Select one of the options given below to reset your password",style: TextStyle(fontSize:16,fontWeight: FontWeight.w500),),
            const SizedBox(height: 30.0,),

            ForegtPasswordBtnWidget(

              btnIcon:Icons.email_rounded,
              tittle:"E-mail",
              subtittle: "Reset via Mail Verification",
              onTap:(){
                Navigator.pop(context);
                Get.to(()=>const ForgetPasswordMailScreen());},
            ),
            SizedBox(height: 20.0,),
            ForegtPasswordBtnWidget(

              btnIcon:Icons.mobile_friendly_rounded,
              tittle:"Phone No",
              subtittle: "Reset via Phone Verification",
              onTap: (){ Get.to(()=>const ForgetPasswordPhoneScreen());},
            )

          ],

        ),
      ),
    );
  }
}
