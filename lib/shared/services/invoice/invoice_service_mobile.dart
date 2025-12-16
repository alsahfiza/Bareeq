import '../invoice/invoice_service.dart';
// import '../invoice_pdf_service.dart';
import '../invoice_mapper.dart';
import '../settings_service.dart';

class InvoiceServiceMobile implements InvoiceService {
  final _pdf = InvoicePdfService();
  final _settings = SettingsService();

  @override
  Future<void> generate({
    required String orderId,
    required bool arabic,
  }) async {
    final order = await _settings.getOrder(orderId);
    final settings = await _settings.getSettingsOnce();

    final invoice = InvoiceMapper.fromOrder(orderId, order);

    await _pdf.generate(
      invoice: invoice,
      sellerName: 'BAREEQ STORE',
      vatNumber: settings.vatRegistrationNumber,
      arabic: arabic,
    );
  }
}

InvoiceService getInvoiceService() => InvoiceServiceMobile();
