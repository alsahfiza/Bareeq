import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/sale_model.dart';
import '../models/customer_models.dart';
import '../services/receipt_generator.dart';


// ==================== RECEIPT PRINTER PROVIDER ====================

class ReceiptPrinterProvider extends ChangeNotifier {
  bool _isPrinting = false;

  bool get isPrinting => _isPrinting;

  // Print receipt (you'll need to integrate with actual printer)
  Future<bool> printReceipt(SaleModel sale, CustomerModel? customer) async {
    _isPrinting = true;
    notifyListeners();

    try {
      // Generate receipt text
      final receiptText = ReceiptGenerator.generateReceiptText(sale, customer);
      
      // TODO: Integrate with your thermal printer
      // For now, we'll just print to console
      debugPrint(receiptText);
      
      // Simulate printing delay
      await Future.delayed(const Duration(seconds: 2));
      
      _isPrinting = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isPrinting = false;
      notifyListeners();
      return false;
    }
  }

  // Print receipt as PDF (for web/mobile)
  Future<bool> printReceiptAsPdf(SaleModel sale, CustomerModel? customer) async {
    // TODO: Implement PDF generation using pdf package
    // For now, return the text
    final receiptText = ReceiptGenerator.generateReceiptText(sale, customer);
    debugPrint(receiptText);
    return true;
  }
}