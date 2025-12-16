import 'invoice_service.dart';

class InvoiceServiceWeb implements InvoiceService {
  @override
  Future<void> generate({
    required String orderId,
    required bool arabic,
  }) async {
    throw UnsupportedError('Invoices are not available on Web');
  }
}

InvoiceService getInvoiceService() => InvoiceServiceWeb();
