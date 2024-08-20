import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:test_4/auth/Driver/driver_signin.dart';

//import '../LogIn_SignIn_Common/login_common.dart';
import '../constants/colors.dart';
import '../constants/image_strings.dart';
import '../constants/sizes.dart';
import '../forgot_password/forgot_password_option/forgot_password_model_sheet.dart';

// class DriverLogin extends StatelessWidget {
//   const DriverLogin({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return common_login(size: size,
//
//       OnTap1:(){Get.to(()=> const ());},
//       OnTap2: (){Get.to(()=> const ());},);
//   }
// }

// class DriverLogin extends StatelessWidget {
//   const DriverLogin({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return SafeArea(
//       child: Scaffold(
//         body: SingleChildScrollView(
//           child: Container(
//             padding: EdgeInsets.all(tDefaultSize),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Column(
//                   children: [
//                     Image(
//                         image: AssetImage(AppLogoImage),
//                         height: size.height * 0.2),
//                     Text(
//                       "Welcome Back",
//                       style: TextStyle(
//                           color: tPrimaryColor,
//                           fontSize: 30,
//                           fontWeight: FontWeight.w900),
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 30,
//                 ),
//                 Form(
//                     child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 20.0),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextFormField(
//                         decoration: InputDecoration(
//                           prefixIcon: Icon(Icons.person_outline_outlined),
//                           labelText: "Email",
//                           hintText: "Enter Your Email",
//                           border: OutlineInputBorder(),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 30.0,
//                       ),
//                       TextFormField(
//                         obscureText: true,
//                         decoration: InputDecoration(
//                             prefixIcon: Icon(Icons.fingerprint_rounded),
//                             labelText: "Password",
//                             hintText: "Enter Your Password",
//                             border: OutlineInputBorder(),
//                             suffixIcon: IconButton(
//                               onPressed: null,
//                               icon: Icon(Icons.remove_red_eye_sharp),
//                             )),
//                       ),
//                       SizedBox(
//                         height: 6,
//                       ),
//                       Align(
//                           alignment: Alignment.centerRight,
//                           child: TextButton(
//                             onPressed: () {
//                               ForgetPasswordScreen.BuildShowModalBottomSheet(
//                                   context);
//                             },
//                             child: Text(
//                               "Forget Password?",
//                             ),
//                           )),
//                       SizedBox(
//                         height: 23,
//                       ),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(
//                           onPressed: () {},
//                           style: OutlinedButton.styleFrom(
//                               shape: RoundedRectangleBorder(),
//                               backgroundColor: Colors.black87,
//                               foregroundColor: Colors.white,
//                               side: BorderSide(color: Colors.black87, width: 2),
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 8, horizontal: 50)),
//                           child: Text("LOGIN"),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 3,
//                       ),
//                       Align(
//                         alignment: Alignment.center,
//                         child: Text("OR", style: TextStyle(fontSize: 13)),
//                       ),
//                       SizedBox(
//                         height: 3,
//                       ),
//                       SizedBox(
//                         width: double.infinity,
//                         child: OutlinedButton.icon(
//                           icon: Image(
//                             image: AssetImage(GoogleLogo),
//                             width: 20,
//                           ),
//                           onPressed: () {},
//                           style: OutlinedButton.styleFrom(
//                               shape: RoundedRectangleBorder(),
//                               foregroundColor: Colors.black54,
//                               side:
//                                   BorderSide(color: Colors.black87, width: 0.7),
//                               padding: EdgeInsets.symmetric(
//                                   vertical: 8, horizontal: 50)),
//                           label: Text("Sign In with Google",
//                               style: TextStyle(fontWeight: FontWeight.w700)),
//                         ),
//                       ),
//                       TextButton(
//                         onPressed: () {
//                           Get.to(() => const driver_signin());
//                         },
//                         child: const Text.rich(TextSpan(
//                             text: "Don't have an Account?",
//                             style: TextStyle(color: Colors.black87),
//                             children: [
//                               TextSpan(
//                                   text: " Sign Up",
//                                   style: TextStyle(color: Colors.blue)),
//                             ])),
//                       ),
//                     ],
//                   ),
//                 ))
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
