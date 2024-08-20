import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:test_4/auth/Role_Selection_Screen/selection_screen.dart';
import 'package:test_4/auth/sign_in.dart';
import 'package:test_4/auth/home_page.dart';
import 'package:test_4/pages/Driver/buslist_driver.dart';
import 'package:test_4/pages/passenger/searchpage_passenger.dart';

//import '../LogIn_SignIn_Common/login_common.dart';
import 'constants/colors.dart';
import 'constants/image_strings.dart';
import 'constants/sizes.dart';
import 'forgot_password/forgot_password_option/forgot_password_model_sheet.dart';

class LogInScreen extends StatelessWidget {
  LogInScreen({super.key});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _loginUser(BuildContext context) async {
    final String email = _emailController.text.trim();
    final String password = _passwordController.text.trim();

    try {
      // Sign in with Firebase Auth
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;
      if (user != null) {
        // Retrieve user role and navigate accordingly
        String role = await _getUserRole(user.uid);

        if (role == 'Driver') {
          Get.to(() => BusListPageDriver());
        } else if (role == 'Passenger') {
          Get.to(() => SearchBusPage());
        } else {
          Get.snackbar('Error', 'Unknown role');
        }
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  Future<String> _getUserRole(String uid) async {
    DocumentSnapshot driverSnapshot = await _firestore.collection('driver').doc(uid).get();
    if (driverSnapshot.exists) {
      return 'Driver';
    }

    DocumentSnapshot passengerSnapshot = await _firestore.collection('passenger').doc(uid).get();
    if (passengerSnapshot.exists) {
      return 'Passenger';
    }

    return 'Unknown';
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            padding: EdgeInsets.all(tDefaultSize),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Image(image: AssetImage(AppLogoImage), height: size.height * 0.2),
                    Text(" Welcome Back", style: TextStyle(color: tPrimaryColor, fontSize: 30, fontWeight: FontWeight.w900)),
                  ],
                ),
                SizedBox(height: 30),
                Form(
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextFormField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.person_outline_outlined),
                            labelText: "Email",
                            hintText: "Enter Your Email",
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
                        ),
                        SizedBox(height: 30.0),
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.fingerprint_rounded),
                            labelText: "Password",
                            hintText: "Enter Your Password",
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.remove_red_eye_sharp),
                            ),
                          ),
                        ),
                        SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: () {
                              ForgetPasswordScreen.BuildShowModalBottomSheet(context);
                            },
                            child: Text("Forget Password?"),
                          ),
                        ),
                        SizedBox(height: 23),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              _loginUser(context);
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(),
                              backgroundColor: Colors.black87,
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.black87, width: 2),
                              padding: EdgeInsets.symmetric(vertical: 8, horizontal: 50),
                            ),
                            child: Text("LOGIN"),
                          ),
                        ),
                        SizedBox(height: 20),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text("Don't have an Account?", style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                        ),
                        SizedBox(height: 3),
                        SizedBox(
                          width: double.infinity,
                          child: OutlinedButton.icon(
                            onPressed: () {
                              Get.to(() => const WelcomeScreen());
                            },
                            style: OutlinedButton.styleFrom(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
                              backgroundColor: tPrimaryColor,
                              foregroundColor: Colors.black54,
                              side: BorderSide(color: Colors.black87, width: 0.7),
                              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 50),
                            ),
                            label: Text("Create a New Account", style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}