import 'dart:io';
import 'package:arabic_reshaper/arabic_reshaper.dart';
import 'package:bidi/bidi.dart' as bidi;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import '../models/invoice_model.dart';
import 'zatca_qr_service.dart';

class InvoicePdfService {
  Future<File> generate({
    required InvoiceModel invoice,
    required String sellerName,
    required String vatNumber,
    required bool arabic,
  }) async {
    final pdf = pw.Document();

    String ar(String text) =>
        bidi.logicalToVisual(
            ArabicReshaper().reshape(text));

    final qr = ZatcaQrService.generate(
      sellerName: sellerName,
      vatNumber: vatNumber,
      timestamp: invoice.createdAt,
      total: invoice.total,
      vat: invoice.vatAmount,
    );

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (_) => pw.Directionality(
          textDirection:
              arabic ? pw.TextDirection.rtl : pw.TextDirection.ltr,
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text(
                arabic ? ar(sellerName) : sellerName,
                style: pw.TextStyle(
                    fontSize: 22,
                    fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                arabic
                    ? ar('الرقم الضريبي: $vatNumber')
                    : 'VAT: $vatNumber',
              ),

              pw.SizedBox(height: 20),

              pw.Table.fromTextArray(
                headers: arabic
                    ? [ar('الإجمالي'), ar('السعر'), ar('الكمية'), ar('الصنف')]
                    : ['Item', 'Qty', 'Price', 'Total'],
                data: invoice.items.map((i) {
                  final t = i.qty * i.price;
                  return arabic
                      ? [
                          t.toStringAsFixed(2),
                          i.price.toStringAsFixed(2),
                          i.qty.toString(),
                          ar(i.name),
                        ]
                      : [
                          i.name,
                          i.qty.toString(),
                          i.price.toStringAsFixed(2),
                          t.toStringAsFixed(2),
                        ];
                }).toList(),
              ),

              pw.SizedBox(height: 20),

              pw.Text(
                arabic
                    ? ar('ضريبة القيمة المضافة (${(invoice.vatRate * 100).toInt()}%): ${invoice.vatAmount}')
                    : 'VAT (${(invoice.vatRate * 100).toInt()}%): ${invoice.vatAmount}',
              ),
              pw.Text(
                arabic
                    ? ar('الإجمالي: ${invoice.total}')
                    : 'TOTAL: ${invoice.total}',
                style: pw.TextStyle(
                    fontSize: 16,
                    fontWeight: pw.FontWeight.bold),
              ),

              pw.SizedBox(height: 20),

              pw.BarcodeWidget(
                barcode: pw.Barcode.qrCode(),
                data: qr,
                width: 120,
                height: 120,
              ),
            ],
          ),
        ),
      ),
    );

    final dir = await getApplicationDocumentsDirectory();
    final file = File(
        '${dir.path}/invoice_${invoice.orderId}_${arabic ? 'ar' : 'en'}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
