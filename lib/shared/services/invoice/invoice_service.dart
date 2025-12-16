import 'invoice_service_mobile.dart'
    if (dart.library.html) 'invoice_service_web.dart';

abstract class InvoiceService {
  Future<void> generate({
    required String orderId,
    required bool arabic,
  });
}

InvoiceService getInvoiceService() {
  throw UnsupportedError('No InvoiceService implementation found');
}
