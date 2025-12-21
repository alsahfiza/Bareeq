import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/product_category_models.dart';
import '../services/firebase_service.dart';


// ==================== PRODUCT PROVIDER ====================
class ProductProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<ProductModel> _products = [];
  List<ProductModel> _filteredProducts = [];
  bool _isLoading = false;
  String? _errorMessage;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;

  List<ProductModel> get products => _filteredProducts.isEmpty ? _products : _filteredProducts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  int get totalProducts => _products.length;

  // Load products with pagination
  Future<void> loadProducts({bool refresh = false}) async {
    if (_isLoading) return;
    
    if (refresh) {
      _products = [];
      _filteredProducts = [];
      _lastDocument = null;
      _hasMore = true;
    }

    if (!_hasMore) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final querySnapshot = await _firebaseService.getCollectionPaginated(
        collection: 'products',
        limit: 20,
        startAfter: _lastDocument,
        queryBuilder: (query) => query.orderBy('createdAt', descending: true),
      );

      if (querySnapshot.docs.isEmpty) {
        _hasMore = false;
      } else {
        _lastDocument = querySnapshot.docs.last;
        
        final newProducts = querySnapshot.docs
            .map((doc) => ProductModel.fromFirestore(doc))
            .toList();
        
        _products.addAll(newProducts);
        
        if (querySnapshot.docs.length < 20) {
          _hasMore = false;
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to load products: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add product
  Future<bool> addProduct(ProductModel product) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firebaseService.createDocument(
        collection: 'products',
        docId: product.id,
        data: product.toJson(),
      );

      _products.insert(0, product);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add product: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update product
  Future<bool> updateProduct(ProductModel product) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firebaseService.updateDocument(
        collection: 'products',
        docId: product.id,
        data: product.toJson(),
      );

      final index = _products.indexWhere((p) => p.id == product.id);
      if (index != -1) {
        _products[index] = product;
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update product: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Delete product
  Future<bool> deleteProduct(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      await _firebaseService.deleteDocument(
        collection: 'products',
        docId: productId,
      );

      _products.removeWhere((p) => p.id == productId);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to delete product: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Search products
  void searchProducts(String query) {
    if (query.isEmpty) {
      _filteredProducts = [];
    } else {
      _filteredProducts = _products.where((product) {
        return product.name.toLowerCase().contains(query.toLowerCase()) ||
               product.description.toLowerCase().contains(query.toLowerCase()) ||
               (product.barcode?.contains(query) ?? false);
      }).toList();
    }
    notifyListeners();
  }

  void clearFilter() {
    _filteredProducts = [];
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}