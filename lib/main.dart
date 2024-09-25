import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:test_4/auth/on_boarding_screen/On_boarding_screen_new.dart';
import 'package:test_4/auth/on_boarding_screen/on_boarding_screen.dart';
import 'package:test_4/pages/Driver/buslist_driver.dart';
import 'package:test_4/pages/UserSelectionPage.dart';
import 'package:test_4/pages/admin.dart';
import 'package:test_4/pages/adminbuslist.dart';
import 'package:test_4/pages/passenger/searchpage_passenger.dart';

import 'auth/log_in.dart';
//import 'package:comproject/Useless/map_page.dart';


void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures that Flutter bindings are initialized
  await Firebase.initializeApp(); // Initializes Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: OnBoardingScreen(),
      //home: AddBusHaltPage (),
    );
  }
}
// void main() async {
//   WidgetsFlutterBinding.ensureInitialized(); // Ensures that Flutter bindings are initialized
//   await Firebase.initializeApp(); // Initializes Firebase
//   runApp( MyApp());
// }
//
// class MyApp extends StatelessWidget {
//    MyApp({super.key});
//
//   final FirebaseAuth _auth = FirebaseAuth.instance;
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//
//   Future<Widget> _getInitialScreen() async {
//     User? user = _auth.currentUser;
//
//     if (user != null) {
//       // User is already logged in, fetch their role
//       String role = await _getUserRole(user.uid);
//       if (role == 'Passenger') {
//         return OnBoardingScreenNew();
//       } else if (role == 'Driver') {
//         return BusListPageDriver();
//       } else if (role == 'Admin') {
//         return RegistrationListPage();
//       }
//     }
//
//     // No user is logged in, show Onboarding Screen
//     return OnBoardingScreen();
//   }
//
//   Future<String> _getUserRole(String uid) async {
//     DocumentSnapshot driverSnapshot = await _firestore.collection('driver').doc(uid).get();
//     if (driverSnapshot.exists) {
//       return 'Driver';
//     }
//
//     DocumentSnapshot passengerSnapshot = await _firestore.collection('passenger').doc(uid).get();
//     if (passengerSnapshot.exists) {
//       return 'Passenger';
//     }
//
//     DocumentSnapshot adminSnapshot = await _firestore.collection('admin').doc(uid).get();
//     if (adminSnapshot.exists) {
//       return 'Admin';
//     }
//
//     return 'Unknown';
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<Widget>(
//       future: _getInitialScreen(),
//       builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           // Show loading spinner while checking authentication state
//           return const MaterialApp(home: Center(child: CircularProgressIndicator()));
//         } else if (snapshot.hasData) {
//           return GetMaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'Flutter Demo',
//             theme: ThemeData(
//               colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//               useMaterial3: true,
//             ),
//             home: snapshot.data!,  // Navigate to the respective page based on the role
//           );
//         } else {
//           // Default to Login screen if any issue occurs
//           return GetMaterialApp(
//             debugShowCheckedModeBanner: false,
//             title: 'Flutter Demo',
//             theme: ThemeData(
//               colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
//               useMaterial3: true,
//             ),
//             home: LogInScreen(),  // Show login screen if no user is found
//           );
//         }
//       },
//     );
//   }
// }