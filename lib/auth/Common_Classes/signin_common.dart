// import 'package:flutter/material.dart';
//
// import '../constants/colors.dart';
// import '../constants/image_strings.dart';
// import '../constants/sizes.dart';
//
// class signin_common extends StatelessWidget {
//   const signin_common({
//
//
//     super.key,
//     required this.size,
//     required this .onTap1,
//     required this .text1,
//     required this. onTap2
//   });
//
//   final Size size;
//   final VoidCallback onTap1;
//   final String text1;
//   final VoidCallback onTap2;
//
//   @override
//   Widget build(BuildContext context) {
//     var height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           padding:const EdgeInsets.all(tDefaultSize),
//           child: Column(
//             children: [
//               Image(image: AssetImage(AppLogoImage),height: size.height*0.2),
//
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children:[
//                   Text("Hello!",style: TextStyle(color: tPrimaryColor,fontSize:30,fontWeight: FontWeight.w900),),
//                   Text(text1,style: TextStyle(color: tPrimaryColor,fontSize:17,fontWeight: FontWeight.w500),),
//
//                 ],
//               ),
//               Container(
//                 padding:const EdgeInsets.symmetric(vertical: tDefaultSize-10),
//                 child: Form(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       TextFormField(
//                         decoration: InputDecoration(
//                             label: Text("Full Name",style: TextStyle(color: tPrimaryColor),),
//                             hintText: "Enter Your  Full Name",
//                             prefixIcon: Icon(Icons.person_outline,color: tPrimaryColor,),
//                             border: OutlineInputBorder(),
//                             focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(width: 2.0,color: tPrimaryColor)
//                             )
//                         ),
//                       ),
//                       SizedBox(height: 12,),
//                       TextFormField(
//                         decoration: InputDecoration(
//                             label: Text("E-mail",style: TextStyle(color: tPrimaryColor),),
//                             hintText: "Enter Your  E-mail Address",
//                             prefixIcon: Icon(Icons.email_outlined,color: tPrimaryColor,),
//                             border: OutlineInputBorder(),
//                             focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(width: 2.0,color: tPrimaryColor)
//                             )
//                         ),
//                       ),
//                       SizedBox(height: 12,),
//                       TextFormField(
//                         decoration: InputDecoration(
//                             label: Text("Phone Number",style: TextStyle(color: tPrimaryColor),),
//                             hintText: "Enter Your  Phone Number",
//                             prefixIcon: Icon(Icons.phone_android,color: tPrimaryColor,),
//                             border: OutlineInputBorder(),
//                             focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(width: 2.0,color: tPrimaryColor)
//                             )
//                         ),
//                       ),
//                       SizedBox(height: 12,),
//                       TextFormField(
//                         obscureText: true,
//                         decoration: InputDecoration(
//                             label: Text("Password",style: TextStyle(color: tPrimaryColor),),
//                             hintText: "Enter a Strong Password",
//                             prefixIcon: Icon(Icons.fingerprint_rounded,color: tPrimaryColor,),
//                             border: OutlineInputBorder(),
//                             focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(width: 2.0,color: tPrimaryColor)
//                             )
//                         ),
//                       ),
//                       SizedBox(height: 50,),
//                       SizedBox(
//                         width: double.infinity,
//                         child: ElevatedButton(onPressed:onTap2,
//
//                           style: OutlinedButton.styleFrom(
//                               shape:RoundedRectangleBorder(),
//                               backgroundColor:Colors.black87,
//                               foregroundColor:Colors.white,
//                               side: BorderSide(color: Colors.black87,width:2),
//                               padding: EdgeInsets.symmetric(vertical:8,horizontal:50)
//                           ),
//
//                           child:Text("SINGUP"),),
//                       ),
//                       SizedBox(height: 3,),
//                       Align(alignment:Alignment.center,child:  Text("OR",style:TextStyle(fontSize:13)),),
//                       SizedBox(height: 3,),
//                       SizedBox(
//                         width:double.infinity,
//                         child: OutlinedButton.icon(
//                           icon: Image(image: AssetImage(GoogleLogo),width: 20,),
//                           onPressed: (){},
//
//                           style: OutlinedButton.styleFrom(
//                               shape:RoundedRectangleBorder(),
//                               foregroundColor:Colors.black54,
//                               side: BorderSide(color: Colors.black87,width:0.7),
//                               padding: EdgeInsets.symmetric(vertical:8,horizontal:50)
//                           ),
//
//                           label:Text("Sing_In with Google",style: TextStyle(fontWeight: FontWeight.w700),),),
//                       ),
//
//                       SizedBox(height: 8,),
//                       TextButton(onPressed:onTap1,
//
//                         child: const Text.rich(
//                             TextSpan(
//                                 text: "Already have an Account?",
//                                 style: TextStyle(color: Colors.black87),
//                                 children: [
//                                   TextSpan(text: " LogIn",
//                                       style: TextStyle(color: Colors.blue)),
//                                 ]
//                             )
//                         ),
//                       ),
//
//
//
//
//
//
//                     ],
//                   ),
//                 ),
//
//               ),
//             ],
//           ),
//         ),
//       ),
//
//     );
//   }
// }
