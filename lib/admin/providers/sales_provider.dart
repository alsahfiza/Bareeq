import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/sale_model.dart';
import '../models/product_category_models.dart';
import '../services/firebase_service.dart';


// ==================== SALES PROVIDER ====================

class SalesProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<SaleModel> _sales = [];
  List<SaleModel> _filteredSales = [];
  bool _isLoading = false;
  String? _errorMessage;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  
  // Current sale being processed (POS Cart)
  List<SaleItem> _currentSaleItems = [];
  double _currentDiscount = 0.0;
  String? _currentCustomerName;
  String? _currentCustomerPhone;
  String? _currentNotes;

  // Getters
  List<SaleModel> get sales => _filteredSales.isEmpty ? _sales : _filteredSales;
  List<SaleItem> get currentSaleItems => _currentSaleItems;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  
  // Current sale calculations
  double get currentSubtotal => SaleModel.calculateSubtotal(_currentSaleItems);
  double get currentDiscount => _currentDiscount;
  double get currentTax => SaleModel.calculateTax(currentSubtotal, 15.0); // 15% VAT in Saudi
  double get currentTotal => SaleModel.calculateTotal(currentSubtotal, _currentDiscount, currentTax);
  int get currentItemCount => _currentSaleItems.fold(0, (sum, item) => sum + item.quantity);

  // Statistics
  int get totalSales => _sales.length;
  double get totalRevenue => _sales.fold(0.0, (sum, sale) => sum + sale.total);
  
  // Today's sales
  List<SaleModel> get todaySales {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return _sales.where((sale) => sale.saleDate.isAfter(startOfDay)).toList();
  }
  
  double get todayRevenue => todaySales.fold(0.0, (sum, sale) => sum + sale.total);
  int get todaySalesCount => todaySales.length;

  // Load sales with pagination
  Future<void> loadSales({bool refresh = false}) async {
    if (_isLoading) return;
    
    if (refresh) {
      _sales = [];
      _filteredSales = [];
      _lastDocument = null;
      _hasMore = true;
    }

    if (!_hasMore) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final querySnapshot = await _firebaseService.getCollectionPaginated(
        collection: 'sales',
        limit: 50, // More sales per page
        startAfter: _lastDocument,
        queryBuilder: (query) => query.orderBy('saleDate', descending: true),
      );

      if (querySnapshot.docs.isEmpty) {
        _hasMore = false;
      } else {
        _lastDocument = querySnapshot.docs.last;
        
        final newSales = querySnapshot.docs
            .map((doc) => SaleModel.fromFirestore(doc))
            .toList();
        
        _sales.addAll(newSales);
        
        if (querySnapshot.docs.length < 50) {
          _hasMore = false;
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to load sales: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter sales by date range
  void filterByDateRange(DateTime start, DateTime end) {
    _filteredSales = _sales.where((sale) {
      return sale.saleDate.isAfter(start) && sale.saleDate.isBefore(end);
    }).toList();
    notifyListeners();
  }

  // Filter by payment method
  void filterByPaymentMethod(PaymentMethod? method) {
    if (method == null) {
      _filteredSales = [];
    } else {
      _filteredSales = _sales.where((sale) => sale.paymentMethod == method).toList();
    }
    notifyListeners();
  }

  // ==================== POS OPERATIONS ====================

  // Add item to current sale
  void addItemToCurrentSale(ProductModel product, {int quantity = 1}) {
    final existingIndex = _currentSaleItems.indexWhere(
      (item) => item.productId == product.id,
    );

    if (existingIndex != -1) {
      // Update quantity if item already exists
      final existing = _currentSaleItems[existingIndex];
      final newQuantity = existing.quantity + quantity;
      final newTotal = SaleItem.calculateItemTotal(
        newQuantity,
        existing.unitPrice,
        existing.discount,
      );

      _currentSaleItems[existingIndex] = existing.copyWith(
        quantity: newQuantity,
        total: newTotal,
      );
    } else {
      // Add new item
      final total = SaleItem.calculateItemTotal(
        quantity,
        product.price,
        0.0,
      );

      _currentSaleItems.add(SaleItem(
        productId: product.id,
        productName: product.name,
        productImage: product.imageUrl,
        barcode: product.id, // Use product ID as barcode for now
        quantity: quantity,
        unitPrice: product.price,
        discount: 0.0,
        total: total,
      ));
    }

    notifyListeners();
  }

  // Remove item from current sale
  void removeItemFromCurrentSale(String productId) {
    _currentSaleItems.removeWhere((item) => item.productId == productId);
    notifyListeners();
  }

  // Update item quantity
  void updateItemQuantity(String productId, int newQuantity) {
    if (newQuantity <= 0) {
      removeItemFromCurrentSale(productId);
      return;
    }

    final index = _currentSaleItems.indexWhere((item) => item.productId == productId);
    if (index != -1) {
      final item = _currentSaleItems[index];
      final newTotal = SaleItem.calculateItemTotal(
        newQuantity,
        item.unitPrice,
        item.discount,
      );

      _currentSaleItems[index] = item.copyWith(
        quantity: newQuantity,
        total: newTotal,
      );
      notifyListeners();
    }
  }

  // Apply discount to entire sale
  void applyDiscount(double discount) {
    _currentDiscount = discount;
    notifyListeners();
  }

  // Set customer info (optional)
  void setCustomerInfo(String? name, String? phone) {
    _currentCustomerName = name;
    _currentCustomerPhone = phone;
    notifyListeners();
  }

  // Set notes
  void setNotes(String? notes) {
    _currentNotes = notes;
    notifyListeners();
  }

  // Complete sale
  Future<bool> completeSale({
    required PaymentMethod paymentMethod,
    required String cashierName,
    required String cashierId,
  }) async {
    if (_currentSaleItems.isEmpty) {
      _errorMessage = 'Cannot complete sale with no items';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // Generate sale number
      final saleNumber = await _generateSaleNumber();

      final sale = SaleModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        saleNumber: saleNumber,
        items: List.from(_currentSaleItems),
        subtotal: currentSubtotal,
        discount: _currentDiscount,
        tax: currentTax,
        total: currentTotal,
        paymentMethod: paymentMethod,
        customerName: _currentCustomerName,
        customerPhone: _currentCustomerPhone,
        cashierName: cashierName,
        cashierId: cashierId,
        saleDate: DateTime.now(),
        notes: _currentNotes,
      );

      // Save to Firestore
      await _firebaseService.createDocument(
        collection: 'sales',
        docId: sale.id,
        data: sale.toJson(),
      );

      // Update product stock
      for (final item in _currentSaleItems) {
        await _updateProductStock(item.productId, item.quantity);
      }

      // Add to local list
      _sales.insert(0, sale);

      // Clear current sale
      clearCurrentSale();

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to complete sale: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update product stock after sale
  Future<void> _updateProductStock(String productId, int soldQuantity) async {
    try {
      final productDoc = await _firebaseService.getDocument(
        collection: 'products',
        docId: productId,
      );

      if (productDoc.exists) {
        final currentStock = productDoc.get('stock') as int;
        final newStock = currentStock - soldQuantity;

        await _firebaseService.updateDocument(
          collection: 'products',
          docId: productId,
          data: {
            'stock': newStock < 0 ? 0 : newStock,
            'updatedAt': FieldValue.serverTimestamp(),
          },
        );
      }
    } catch (e) {
      debugPrint('Failed to update stock for $productId: $e');
    }
  }

  // Generate unique sale number
  Future<String> _generateSaleNumber() async {
    final today = DateTime.now();
    final datePrefix = '${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}';
    
    // Get count of today's sales
    final todayCount = todaySales.length + 1;
    
    return 'SALE-$datePrefix-${todayCount.toString().padLeft(4, '0')}';
  }

  // Clear current sale (cancel)
  void clearCurrentSale() {
    _currentSaleItems = [];
    _currentDiscount = 0.0;
    _currentCustomerName = null;
    _currentCustomerPhone = null;
    _currentNotes = null;
    notifyListeners();
  }

  // Get sale by ID
  SaleModel? getSaleById(String saleId) {
    try {
      return _sales.firstWhere((s) => s.id == saleId);
    } catch (e) {
      return null;
    }
  }

  // Get sales summary by date
  Map<String, double> getSalesSummary(DateTime start, DateTime end) {
    final salesInRange = _sales.where((sale) {
      return sale.saleDate.isAfter(start) && sale.saleDate.isBefore(end);
    }).toList();

    return {
      'totalSales': salesInRange.length.toDouble(),
      'totalRevenue': salesInRange.fold(0.0, (sum, sale) => sum + sale.total),
      'totalDiscount': salesInRange.fold(0.0, (sum, sale) => sum + sale.discount),
      'totalTax': salesInRange.fold(0.0, (sum, sale) => sum + sale.tax),
      'averageSale': salesInRange.isEmpty 
          ? 0.0 
          : salesInRange.fold(0.0, (sum, sale) => sum + sale.total) / salesInRange.length,
    };
  }

  // Clear filter
  void clearFilter() {
    _filteredSales = [];
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}