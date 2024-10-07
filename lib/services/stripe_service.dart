import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:test_4/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:test_4/pages/passenger/seat_booking.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();
  

  Future<void> makePayment(int seatCount, String busId, List<int> selectedSeats, String driverId, List<Map<String, dynamic>> selectedSeatInfo) async {
        print('Making payment for $seatCount seats for bus $busId with driver $driverId.');
    print('Selected seats: $selectedSeatInfo'); // Print the seat info (row and column)
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(
        100 * seatCount,
        "usd",
        
      );
      if (paymentIntentClientSecret == null) return;
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Daham Adikari",
        ),
      );
      //await _processPayment();
      bool paymentSuccessful = await _processPayment();


    // If payment is successful, update seat status in Firestore
    //await _updateSeatStatus(busId, selectedSeats);

    // Only update Firestore if payment is successful
    if (paymentSuccessful) {
      await _updateSeatStatus(busId, selectedSeatInfo, driverId);
      print("Seats updated successfully in Firestore.");
    } else {
      print("Payment failed, seats not updated.");
    }

    } catch (e) {
      print(e);
    }

  }



  Future<void> _updateSeatStatus(String busId, List<Map<String, dynamic>> selectedSeatInfo, String driverId) async {
  try {
    // Fetch the Firestore document for the bus
    DocumentReference busRef = FirebaseFirestore.instance
        .collection('driver')
        .doc(driverId)
        .collection('buses')
        .doc(busId);
    
    DocumentSnapshot doc = await busRef.get();
    if (doc.exists && doc.data() != null) {
      var data = doc.data() as Map<String, dynamic>;
      
      // Access seatData and then seatLayout inside it
      if (data.containsKey('seatData') && data['seatData'] != null) {
        Map<String, dynamic> seatData = data['seatData'];
        List<dynamic> seatLayout = seatData['seatLayout'];

        // Update the status of the selected seats to 'booked'
        for (Map<String, dynamic> seatInfo in selectedSeatInfo) {
          int index = seatInfo['index']; // Extract the seat index from the info
          seatLayout[index]['status'] = 'booked'; // Set the status to 'booked'
        }

        // Save the updated seatLayout back inside seatData, and update Firestore
        seatData['seatLayout'] = seatLayout;
        await busRef.update({'seatData': seatData});

        print("Seat status updated successfully.");
      } else {
        print("No seatData found.");
      }
    } else {
      print("Bus document does not exist.");
    }
  } catch (e) {
    print('Error updating seat status: $e');
  }
}






  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(
          amount,
        ),
        "currency": currency,
      };
      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded'
          },
        ),
      );
      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<bool> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
      print("Payment successful");
    return true; // Return true if payment is successful
    } catch (e) {
      print('error');
      return false;
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
