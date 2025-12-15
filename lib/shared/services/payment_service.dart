import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentService {
  static Future<void> init() async {
    Stripe.publishableKey =
        const String.fromEnvironment('STRIPE_PUBLISHABLE_KEY');
    await Stripe.instance.applySettings();
  }

  Future<void> pay({
    required double amount,
    required String orderId,
  }) async {
    final intent = await _createPaymentIntent(amount);

    await Stripe.instance.initPaymentSheet(
      paymentSheetParameters: SetupPaymentSheetParameters(
        paymentIntentClientSecret: intent['client_secret'],
        merchantDisplayName: 'Bareeq Store',
      ),
    );

    await Stripe.instance.presentPaymentSheet();

    await FirebaseFirestore.instance
        .collection('orders')
        .doc(orderId)
        .update({
      'status': 'paid',
      'paidAt': DateTime.now().toIso8601String(),
    });
  }

  Future<Map<String, dynamic>> _createPaymentIntent(
      double amount) async {
    final response = await http.post(
      Uri.parse(
          'https://api.stripe.com/v1/payment_intents'),
      headers: {
        'Authorization':
            'Bearer ${const String.fromEnvironment('STRIPE_SECRET_KEY')}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {
        'amount': (amount * 100).toInt().toString(),
        'currency': 'usd',
      },
    );

    return jsonDecode(response.body);
  }
}
