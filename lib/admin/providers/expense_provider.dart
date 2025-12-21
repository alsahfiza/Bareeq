import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import '../models/advanced_features.dart';
import '../services/firebase_service.dart';

// ==================== EXPENSE PROVIDER ====================
class ExpenseProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<ExpenseModel> _expenses = [];
  List<ExpenseModel> _filteredExpenses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<ExpenseModel> get expenses => _filteredExpenses.isEmpty ? _expenses : _filteredExpenses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Get today's expenses
  List<ExpenseModel> get todayExpenses {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    return _expenses.where((exp) => exp.date.isAfter(startOfDay)).toList();
  }

  double get todayTotal => todayExpenses.fold(0.0, (sum, exp) => sum + exp.amount);
  
  // Get this month's expenses
  List<ExpenseModel> get monthExpenses {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    return _expenses.where((exp) => exp.date.isAfter(startOfMonth)).toList();
  }

  double get monthTotal => monthExpenses.fold(0.0, (sum, exp) => sum + exp.amount);

  // Load expenses
  Future<void> loadExpenses() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final snapshot = await _firebaseService.getCollectionStream(
        collection: 'expenses',
        queryBuilder: (query) => query.orderBy('date', descending: true),
      ).first;

      _expenses = snapshot.docs
          .map((doc) => ExpenseModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      _errorMessage = 'Failed to load expenses: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add expense
  Future<void> addExpense({
    required String description,
    required double amount,
    required String category,           // String from UI
    required String paymentMethod,      // String from UI
    required DateTime date,
    String? receiptUrl,
    String? notes,
  }) async {
    try {
      final currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser == null) {
        throw Exception('User not authenticated');
      }

      final expenseId = DateTime.now().millisecondsSinceEpoch.toString();
      
      final expense = ExpenseModel(
        id: expenseId,
        description: description,
        amount: amount,
        category: _parseExpenseCategory(category),      // ✅ Convert String to enum
        paymentMethod: _parsePaymentMethod(paymentMethod), // ✅ Convert String to enum
        date: date,
        receiptUrl: receiptUrl,
        notes: notes,
        addedBy: currentUser.displayName ?? 'Unknown',
        addedById: currentUser.uid,
      );

      await _firebaseService.createDocument(
        collection: 'expenses',
        docId: expenseId,
        data: expense.toFirestore(),  // ✅ Use toFirestore()
      );

      _expenses.add(expense);
      notifyListeners();
    } catch (e) {
      print('Error adding expense: $e');
      rethrow;
    }
  }

  // Helper methods (should already exist):
  ExpenseCategory _parseExpenseCategory(String category) {
    switch (category.toLowerCase()) {
      case 'rent':
        return ExpenseCategory.rent;
      case 'utilities':
        return ExpenseCategory.utilities;
      case 'salaries':
        return ExpenseCategory.salaries;
      case 'supplies':
        return ExpenseCategory.supplies;
      case 'equipment':
        return ExpenseCategory.equipment;
      case 'maintenance':
        return ExpenseCategory.maintenance;
      case 'marketing':
        return ExpenseCategory.marketing;
      case 'insurance':
        return ExpenseCategory.insurance;
      case 'taxes':
        return ExpenseCategory.taxes;
      case 'transportation':
        return ExpenseCategory.transportation;
      default:
        return ExpenseCategory.other;
    }
  }

  PaymentMethod _parsePaymentMethod(String method) {
    switch (method.toLowerCase()) {
      case 'cash':
        return PaymentMethod.cash;
      case 'banktransfer':
        return PaymentMethod.bankTransfer;
      case 'creditcard':
        return PaymentMethod.creditCard;
      case 'cheque':
        return PaymentMethod.cheque;
      default:
        return PaymentMethod.other;
    }
  }

  // Generate expense number
  Future<String> _generateExpenseNumber() async {
    final today = DateTime.now();
    final datePrefix = '${today.year}${today.month.toString().padLeft(2, '0')}${today.day.toString().padLeft(2, '0')}';
    final todayCount = todayExpenses.length + 1;
    return 'EXP-$datePrefix-${todayCount.toString().padLeft(4, '0')}';
  }

  // Filter by category
  void filterByCategory(String? category) {
    if (category == null || category.isEmpty) {
      _filteredExpenses = [];
    } else {
      _filteredExpenses = _expenses.where((exp) => exp.category == category).toList();
    }
    notifyListeners();
  }

  // Filter by date range
  void filterByDateRange(DateTime start, DateTime end) {
    _filteredExpenses = _expenses.where((exp) {
      return exp.date.isAfter(start) && exp.date.isBefore(end);
    }).toList();
    notifyListeners();
  }

  // Get expenses by category summary
  Map<String, double> getExpensesByCategory() {
    final Map<String, double> summary = {};
    for (final expense in _expenses) {
      summary[expense.category.name] = (summary[expense.category.name] ?? 0) + expense.amount;
    }
    return summary;
  }

  // Clear filter
  void clearFilter() {
    _filteredExpenses = [];
    notifyListeners();
  }
}
