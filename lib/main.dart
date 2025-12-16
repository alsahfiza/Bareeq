import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'core/firebase/firebase_options.dart';
import 'shared/services/payment/payment_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (!kIsWeb) {
    final paymentService = getPaymentService();
    await paymentService.pay(amount: 0, orderId: 'init');
  }

  runApp(const App());
}
