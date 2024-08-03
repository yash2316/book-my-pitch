import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Payment {
  late Map<String, dynamic>? paymentIntent;
  late Map<String, dynamic> body;

  Payment.obj({required Map<String, dynamic> obj}) {
    body = obj;
  }

  Future createPaymentIntent() async {
    try {
      //Request body

      //Make post request to Stripe
      var response = await http.post(
        Uri.parse(
            'https://yashxx07-futsal-backend.hf.space/create-payment-intent/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );

      return json.decode(response.body)['res'];
    } catch (err) {
      print('ERROR: $err');
    }
  }

  Future<void> makePayment(BuildContext context) async {
    try {
      paymentIntent = await createPaymentIntent();
      print('paymentintent :$paymentIntent');
      if (paymentIntent == null || paymentIntent == '') return;
      Stripe.publishableKey =
          "pk_test_51PagRwRpwI0FVFlq8DMHDSlxS6nCMd4qyJoWs8IjYXKrOh0H1YlgZV4ulKvHFoddc56brTZByh6A70A2iZwck4FQ00PRfg0Bxj";
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  paymentIntentClientSecret: paymentIntent![
                      'client_secret'], //Gotten from payment intent
                  style: ThemeMode.light,
                  merchantDisplayName: 'BookMyPitch'))
          .then((value) {});

      //STEP 3: Display Payment sheet

      displayPaymentSheet(context);
    } catch (err) {
      print(err);
    }
  }

  displayPaymentSheet(BuildContext context) async {
    try {
      await Stripe.instance.presentPaymentSheet().then((value) async {
        try {
          await http.post(
              Uri.parse(
                  'https://yashxx07-futsal-backend.hf.space/confirm-slot/'),
              headers: {'Content-Type': 'application/json'},
              body: jsonEncode(body));
        } catch (e) {
          print(e);
        }

        showDialog(
            context: context,
            builder: (_) => const AlertDialog(
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.check_circle,
                        color: Colors.green,
                        size: 100.0,
                      ),
                      SizedBox(height: 10.0),
                      Text("Payment Successful!"),
                    ],
                  ),
                ));

        paymentIntent = null;
      }).onError((error, stackTrace) {
        throw Exception(error);
      });
    } on StripeException catch (e) {
      print('Error is:---> $e');
      const AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: const [
                Icon(
                  Icons.cancel,
                  color: Colors.red,
                ),
                Text("Payment Failed"),
              ],
            ),
          ],
        ),
      );
    } catch (e) {
      print('$e');
    }
  }
}
