import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:test_4/pages/Driver/buslist_driver.dart';
import 'package:test_4/pages/passenger/searchpage_passenger.dart';
import 'home_page.dart';
import 'log_in.dart';
import 'constants/colors.dart';
import 'constants/image_strings.dart';
import 'constants/sizes.dart';

class SignInScreen extends StatelessWidget {
  final String role;
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  SignInScreen({super.key, required this.role});

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Create user with email and password
        UserCredential userCredential =
            await _auth.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Store user details in Firestore
        await _firestore
            .collection(role.toLowerCase())
            .doc(userCredential.user!.uid)
            .set({
          'full_name': _nameController.text.trim(),
          'email': _emailController.text.trim(),
          'role': role,
          'userID': userCredential.user!.uid,
        });

        // Navigate to the appropriate page based on the role
        if (role.toLowerCase() == 'passenger') {
          Get.to(() => SearchBusPage());
        } else if (role.toLowerCase() == 'driver') {
          Get.to(() => BusListPageDriver());
        }
      } catch (e) {
        // Handle errors
        Get.snackbar("Error", e.toString());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(tDefaultSize),
          child: Column(
            children: [
              Image(image: AssetImage(AppLogoImage), height: size.height * 0.2),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello!",
                    style: TextStyle(
                        color: tPrimaryColor,
                        fontSize: 30,
                        fontWeight: FontWeight.w900),
                  ),
                  Text(
                    "Create Your Profile to Start with BusHub",
                    style: TextStyle(
                        color: tPrimaryColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(vertical: tDefaultSize - 10),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          label: Text("Full Name",
                              style: TextStyle(color: tPrimaryColor)),
                          hintText: "Enter Your Full Name",
                          prefixIcon:
                              Icon(Icons.person_outline, color: tPrimaryColor),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2.0, color: tPrimaryColor),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your full name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          label: Text("E-mail",
                              style: TextStyle(color: tPrimaryColor)),
                          hintText: "Enter Your E-mail Address",
                          prefixIcon:
                              Icon(Icons.email_outlined, color: tPrimaryColor),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2.0, color: tPrimaryColor),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your email';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          label: Text("Password",
                              style: TextStyle(color: tPrimaryColor)),
                          hintText: "Enter Your Password",
                          prefixIcon: Icon(Icons.fingerprint_rounded,
                              color: tPrimaryColor),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2.0, color: tPrimaryColor),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your password';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 12),
                      TextFormField(
                        controller: _confirmPasswordController,
                        obscureText: true,
                        decoration: InputDecoration(
                          label: Text("Confirm Password",
                              style: TextStyle(color: tPrimaryColor)),
                          hintText: "Re-enter Your Password",
                          prefixIcon: Icon(Icons.fingerprint_rounded,
                              color: tPrimaryColor),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide:
                                BorderSide(width: 2.0, color: tPrimaryColor),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please confirm your password';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 50),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _signUp, // Call the sign-up method
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(),
                            backgroundColor: Colors.black87,
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.black87, width: 2),
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 50),
                          ),
                          child: Text("SIGNUP"),
                        ),
                      ),
                      SizedBox(height: 3),
                      Align(
                        alignment: Alignment.center,
                        child: Text("OR", style: TextStyle(fontSize: 13)),
                      ),
                      SizedBox(height: 3),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          icon: Image(image: AssetImage(GoogleLogo), width: 20),
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(),
                            foregroundColor: Colors.black54,
                            side: BorderSide(color: Colors.black87, width: 0.7),
                            padding: EdgeInsets.symmetric(
                                vertical: 8, horizontal: 50),
                          ),
                          label: Text("Sign In with Google",
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                      ),
                      SizedBox(height: 8),
                      TextButton(
                        onPressed: () {
                          Get.to(() =>  LogInScreen());
                        },
                        child: const Text.rich(
                          TextSpan(
                            text: "Already have an Account?",
                            style: TextStyle(color: Colors.black87),
                            children: [
                              TextSpan(
                                text: " LogIn",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
