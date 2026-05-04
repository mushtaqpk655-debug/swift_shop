import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  // --- UPDATED FOR SECURITY ---
  // This looks for 'STRIPE_SECRET_KEY' during the build process.
  // If not found (like when running locally), it uses your fallback test key.
  static const String _secretKey = String.fromEnvironment(
    'STRIPE_SECRET_KEY',
    defaultValue: '',
  );

  static Future<Map<String, dynamic>> createPaymentIntent(String amount, String currency) async {
    try {
      Map<String, dynamic> body = {
        'amount': amount,
        'currency': currency,
        'payment_method_types[]': 'card'
      };

      var response = await http.post(
        Uri.parse('https://api.stripe.com/v1/payment_intents'),
        headers: {
          'Authorization': 'Bearer $_secretKey', // This uses the injected secret
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to create payment intent: ${response.body}');
      }

      return jsonDecode(response.body);
    } catch (err) {
      throw Exception("Stripe API Error: $err");
    }
  }

  static Future<void> makePayment(String amountInAED) async {
    try {
      // 1. Convert AED to Fils (Multiply by 100)
      int amountCalculated = (double.parse(amountInAED) * 100).toInt();

      // 2. Create Payment Intent
      final paymentIntent = await createPaymentIntent(
          amountCalculated.toString(),
          'AED'
      );

      // 3. Initialize Payment Sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          paymentIntentClientSecret: paymentIntent['client_secret'],
          merchantDisplayName: 'Swift Shop UAE',
          style: ThemeMode.light,
        ),
      );

      // 4. Display Payment Sheet
      await Stripe.instance.presentPaymentSheet();

    } catch (e) {
      if (e is StripeException) {
        throw Exception("Stripe Error: ${e.error.localizedMessage}");
      } else {
        throw Exception("Payment Error: $e");
      }
    }
  }
}