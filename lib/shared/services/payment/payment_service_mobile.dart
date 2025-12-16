import 'package:flutter_stripe/flutter_stripe.dart';
import 'payment_service.dart';

class PaymentServiceMobile implements PaymentService {
  PaymentServiceMobile() {
    Stripe.publishableKey = 'YOUR_STRIPE_PUBLISHABLE_KEY';
  }

  @override
  Future<void> pay({
    required double amount,
    required String orderId,
  }) async {
    await Stripe.instance.presentPaymentSheet();
  }
}

PaymentService getPaymentService() => PaymentServiceMobile();
