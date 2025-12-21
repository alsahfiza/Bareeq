import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/advanced_features.dart';
import '../services/firebase_service.dart';


// ==================== CUSTOMER/LOYALTY PROVIDER ====================
class CustomerProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<CustomerModel> _customers = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<CustomerModel> get customers => _customers;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Load customers
  Future<void> loadCustomers() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firebaseService.getCollectionStream(
        collection: 'customers',
        queryBuilder: (query) => query.orderBy('name'),
      ).first;

      _customers = snapshot.docs
          .map((doc) => CustomerModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      _errorMessage = 'Failed to load customers: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Find customer by phone
  CustomerModel? findByPhone(String phone) {
    try {
      return _customers.firstWhere((c) => c.phone == phone);
    } catch (e) {
      return null;
    }
  }

  // Add new customer
  Future<bool> addCustomer({
    required String name,
    required String phone,
    String? email,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final customer = CustomerModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: name,
        phone: phone,
        email: email,
        createdAt: DateTime.now(),
      );

      await _firebaseService.createDocument(
        collection: 'customers',
        docId: customer.id,
        data: customer.toJson(),
      );

      _customers.add(customer);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to add customer: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update customer after purchase
  Future<void> updateCustomerPurchase({
    required String customerId,
    required double amount,
  }) async {
    try {
      final customer = _customers.firstWhere((c) => c.id == customerId);
      final pointsEarned = CustomerModel.calculatePoints(amount);

      final updatedCustomer = customer.copyWith(
        loyaltyPoints: customer.loyaltyPoints + pointsEarned,
        totalSpent: customer.totalSpent + amount,
        totalPurchases: customer.totalPurchases + 1,
        lastPurchaseDate: DateTime.now(),
      );

      await _firebaseService.updateDocument(
        collection: 'customers',
        docId: customerId,
        data: updatedCustomer.toJson(),
      );

      final index = _customers.indexWhere((c) => c.id == customerId);
      if (index != -1) {
        _customers[index] = updatedCustomer;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to update customer purchase: $e');
    }
  }

  // Redeem points
  Future<double> redeemPoints(String customerId, int points) async {
    try {
      final customer = _customers.firstWhere((c) => c.id == customerId);
      
      if (customer.loyaltyPoints < points) {
        throw Exception('Insufficient points');
      }

      final discount = CustomerModel.pointsToDiscount(points);
      final updatedCustomer = customer.copyWith(
        loyaltyPoints: customer.loyaltyPoints - points,
      );

      await _firebaseService.updateDocument(
        collection: 'customers',
        docId: customerId,
        data: updatedCustomer.toJson(),
      );

      final index = _customers.indexWhere((c) => c.id == customerId);
      if (index != -1) {
        _customers[index] = updatedCustomer;
        notifyListeners();
      }

      return discount;
    } catch (e) {
      throw Exception('Failed to redeem points: $e');
    }
  }

  // Get top customers
  List<CustomerModel> getTopCustomers(int limit) {
    final sorted = List<CustomerModel>.from(_customers)
      ..sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
    return sorted.take(limit).toList();
  }
}