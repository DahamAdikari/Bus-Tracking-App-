// import 'package:flutter/material.dart';
//
// import '../constants/colors.dart';
// import '../constants/image_strings.dart';
// import '../constants/sizes.dart';
// import '../forgot_password/forgot_password_option/forgot_password_model_sheet.dart';
//
// class common_login extends StatelessWidget {
//   const common_login({
//     super.key,
//     required this.size,
//     required this.OnTap1,
//     required this.OnTap2
//
//   });
//
//   final Size size;
//   final VoidCallback OnTap1,OnTap2;
//
//
//   @override
//   Widget build(BuildContext context) {
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
//                       padding: EdgeInsets.symmetric(vertical: 20.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           TextFormField(
//                             decoration: InputDecoration(
//                               prefixIcon: Icon(Icons.person_outline_outlined),
//                               labelText: "email",
//                               hintText: "Enter Your Email in Here",
//                               border: OutlineInputBorder(),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 30.0,
//                           ),
//                           TextFormField(
//                             obscureText: true,
//                             decoration: InputDecoration(
//                                 prefixIcon: Icon(Icons.fingerprint_rounded),
//                                 labelText: "password",
//                                 hintText: "Enter Your Password in Here",
//                                 border: OutlineInputBorder(),
//                                 suffixIcon: IconButton(
//                                   onPressed: null,
//                                   icon: Icon(Icons.remove_red_eye_sharp),
//                                 )),
//                           ),
//                           SizedBox(
//                             height: 6,
//                           ),
//                           Align(
//                               alignment: Alignment.centerRight,
//                               child: TextButton(
//                                 onPressed: () {
//                                   ForgetPasswordScreen.BuildShowModalBottomSheet(context);
//                                 },
//                                 child: Text(
//                                   "Forget Password?",
//                                 ),
//                               )),
//                           SizedBox(
//                             height: 23,
//                           ),
//                           SizedBox(
//                             width: double.infinity,
//                             child: ElevatedButton(
//                               onPressed:OnTap2,
//                               style: OutlinedButton.styleFrom(
//                                   shape: RoundedRectangleBorder(),
//                                   backgroundColor: Colors.black87,
//                                   foregroundColor: Colors.white,
//                                   side: BorderSide(
//                                       color: Colors.black87, width: 2),
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 8, horizontal: 50)),
//                               child: Text("LOGIN"),
//                             ),
//                           ),
//                           SizedBox(
//                             height: 3,
//                           ),
//                           Align(
//                             alignment: Alignment.center,
//                             child: Text("OR", style: TextStyle(fontSize: 13)),
//                           ),
//                           SizedBox(
//                             height: 3,
//                           ),
//                           SizedBox(
//                             width: double.infinity,
//                             child: OutlinedButton.icon(
//                               icon: Image(
//                                 image: AssetImage(GoogleLogo),
//                                 width: 20,
//                               ),
//                               onPressed: ()=>{},
//                               style: OutlinedButton.styleFrom(
//                                   shape: RoundedRectangleBorder(),
//                                   foregroundColor: Colors.black54,
//                                   side:
//                                   BorderSide(color: Colors.black87, width: 0.7),
//                                   padding: EdgeInsets.symmetric(
//                                       vertical: 8, horizontal: 50)),
//                               label: Text("Sign_In with Google",
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w700)),
//                             ),
//                           ),
//                           TextButton(
//                             onPressed:OnTap1,
//                             child: const Text.rich(TextSpan(
//                                 text: "Don't have an Account?",
//                                 style: TextStyle(color: Colors.black87),
//                                 children: [
//                                   TextSpan(
//                                       text: " SignUp",
//                                       style: TextStyle(color: Colors.blue)),
//                                 ])),
//                           ),
//                         ],
//                       ),
//                     ))
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
