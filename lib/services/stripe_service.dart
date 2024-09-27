import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:test_4/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:test_4/pages/passenger/seat_booking.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<void> makePayment(int seatCount, String busId, List<int> selectedSeats) async {
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
      await _processPayment();

    // If payment is successful, update seat status in Firestore
    await _updateSeatStatus(busId, selectedSeats);

    } catch (e) {
      print(e);
    }
  }



  Future<void> _updateSeatStatus(String busId, List<int> selectedSeats) async {
  try {
    // Fetch the Firestore document for the bus
    DocumentReference busRef = FirebaseFirestore.instance
        //.collection('driver')
        //.doc(driverId)
        .collection('buses')
        .doc(busId);
    
    DocumentSnapshot doc = await busRef.get();
    if (doc.exists && doc.data() != null) {
      var data = doc.data() as Map<String, dynamic>;
      List<dynamic> seatLayout = data['seatLayout'];

      // Update the status of the selected seats to 'booked'
      for (int index in selectedSeats) {
        seatLayout[index]['status'] = 'booked';
      }

      // Save the updated seat layout back to Firestore
      await busRef.update({'seatLayout': seatLayout});
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

  Future<void> _processPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();
      await Stripe.instance.confirmPaymentSheetPayment();
    } catch (e) {
      print(e);
    }
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
