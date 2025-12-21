import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/product_category_models.dart';


// ==================== BARCODE SCANNER PROVIDER ====================
class BarcodeScannerProvider extends ChangeNotifier {
  String? _lastScannedBarcode;
  bool _isScanning = false;

  String? get lastScannedBarcode => _lastScannedBarcode;
  bool get isScanning => _isScanning;

  // Start scanning
  void startScanning() {
    _isScanning = true;
    notifyListeners();
  }

  // Stop scanning
  void stopScanning() {
    _isScanning = false;
    notifyListeners();
  }

  // Process scanned barcode
  void processScan(String barcode) {
    _lastScannedBarcode = barcode;
    _isScanning = false;
    notifyListeners();
  }

  // Clear last scan
  void clearScan() {
    _lastScannedBarcode = null;
    notifyListeners();
  }

  // Find product by barcode
  ProductModel? findProductByBarcode(String barcode, List<ProductModel> products) {
    try {
      return products.firstWhere(
        (product) => product.id == barcode || product.name.contains(barcode),
      );
    } catch (e) {
      return null;
    }
  }
}