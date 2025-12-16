import 'payment_service_mobile.dart'
    if (dart.library.html) 'payment_service_web.dart';

abstract class PaymentService {
  Future<void> pay({
    required double amount,
    required String orderId,
  });
}

PaymentService getPaymentService() {
  throw UnsupportedError('No PaymentService implementation found');
}
