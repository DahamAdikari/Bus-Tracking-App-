import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:test_4/consts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class StripeService {
  StripeService._();

  static final StripeService instance = StripeService._();

  Future<bool> makePayment(int seatCount, String busId, List<int> selectedSeats,
      String driverId) async {
    try {
      String? paymentIntentClientSecret = await _createPaymentIntent(
        100 * seatCount, // Adjust price per seat
        "usd",
      );
      if (paymentIntentClientSecret == null) return false;

      // Initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntentClientSecret,
          merchantDisplayName: "Daham Adikari",
        ),
      );

      // Process payment and update seat status if payment is successful
      bool paymentSuccessful = await _processPayment();
      if (paymentSuccessful) {
        // Update seat status in Firestore
        await _updateSeatStatus(busId, selectedSeats, driverId);
        return true;
      } else {
        print("Payment was not successful, seat status will not be updated.");
        return false;
      }
    } catch (e) {
      print("Error in makePayment:");
      print(e);
      return false;
    }
  }

  Future<void> _updateSeatStatus(
      String busId, List<int> selectedSeats, String driverId) async {
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

        // Access 'seatData' and then 'seatLayout' inside it
        var seatData = data['seatData'] as Map<String, dynamic>?;
        if (seatData != null) {
          List<dynamic> seatLayout = seatData['seatLayout'] as List<dynamic>;

          // Update the status of the selected seats to 'booked'
          for (int index in selectedSeats) {
            if (index >= 0 && index < seatLayout.length) {
              var seat = seatLayout[index] as Map<String, dynamic>?;
              if (seat != null) {
                seat['status'] = 'booked'; // Update seat status
              }
            } else {
              print('Index $index is out of bounds for seatLayout.');
            }
          }

          // Save the updated seat layout back to Firestore
          await busRef.update({'seatData.seatLayout': seatLayout});
          print('Seat status updated successfully.');
        } else {
          print('Seat data is empty or invalid.');
        }
      }
    } catch (e) {
      print('Error updating seat status: $e');
    }
  }

  Future<String?> _createPaymentIntent(int amount, String currency) async {
    try {
      final Dio dio = Dio();
      Map<String, dynamic> data = {
        "amount": _calculateAmount(amount),
        "currency": currency,
      };

      var response = await dio.post(
        "https://api.stripe.com/v1/payment_intents",
        data: data,
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          headers: {
            "Authorization": "Bearer $stripeSecretKey",
            "Content-Type": 'application/x-www-form-urlencoded',
          },
        ),
      );

      if (response.data != null) {
        return response.data["client_secret"];
      }
      return null;
    } catch (e) {
      print("Error in createPaymentIntent:");
      print(e);
      return null;
    }
  }

  Future<bool> _processPayment() async {
    try {
      // Present the payment sheet (it also confirms the payment)
      await Stripe.instance.presentPaymentSheet();
      print("Payment successful.");
      return true;
    } on StripeException catch (e) {
      if (e.error?.code == 'Canceled') {
        print('Payment canceled by user.');
      } else {
        print("StripeException during payment: $e");
      }
    } catch (e) {
      print("Unknown error in _processPayment:");
      print(e);
    }
    return false; // Return false if payment failed
  }

  String _calculateAmount(int amount) {
    final calculatedAmount = amount * 100;
    return calculatedAmount.toString();
  }
}
