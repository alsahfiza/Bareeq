import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../services/firebase_service.dart';
import '../models/advanced_features.dart';
import '../models/product_category_models.dart';


// ==================== ORDER PROVIDER ====================

class OrderProvider extends ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  
  List<OrderModel> _orders = [];
  List<OrderModel> _filteredOrders = [];
  bool _isLoading = false;
  String? _errorMessage;
  DocumentSnapshot? _lastDocument;
  bool _hasMore = true;
  OrderStatus? _statusFilter;

  // Getters
  List<OrderModel> get orders => _filteredOrders.isEmpty && _statusFilter == null
      ? _orders
      : _filteredOrders;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get hasMore => _hasMore;
  OrderStatus? get statusFilter => _statusFilter;

  // Statistics
  int get totalOrders => _orders.length;
  int get pendingOrders => _orders.where((o) => o.status == OrderStatus.pending).length;
  int get processingOrders => _orders.where((o) => o.status == OrderStatus.processing).length;
  int get deliveredOrders => _orders.where((o) => o.status == OrderStatus.delivered).length;
  double get totalRevenue => _orders
      .where((o) => o.status == OrderStatus.delivered)
      .fold(0.0, (sum, order) => sum + order.total);

  // Load orders with pagination
  Future<void> loadOrders({bool refresh = false}) async {
    if (_isLoading) return;
    
    if (refresh) {
      _orders = [];
      _filteredOrders = [];
      _lastDocument = null;
      _hasMore = true;
    }

    if (!_hasMore) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final querySnapshot = await _firebaseService.getCollectionPaginated(
        collection: 'orders',
        limit: 20,
        startAfter: _lastDocument,
        queryBuilder: (query) {
          Query resultQuery = query.orderBy('createdAt', descending: true);
          
          // Apply status filter if selected
          if (_statusFilter != null) {
            resultQuery = resultQuery.where('status', isEqualTo: _statusFilter!.name);
          }
          
          return resultQuery;
        },
      );

      if (querySnapshot.docs.isEmpty) {
        _hasMore = false;
      } else {
        _lastDocument = querySnapshot.docs.last;
        
        final newOrders = querySnapshot.docs
            .map((doc) => OrderModel.fromFirestore(doc))
            .toList();
        
        _orders.addAll(newOrders);
        
        if (querySnapshot.docs.length < 20) {
          _hasMore = false;
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to load orders: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Filter orders by status
  void filterByStatus(OrderStatus? status) {
    _statusFilter = status;
    
    if (status == null) {
      _filteredOrders = [];
    } else {
      _filteredOrders = _orders.where((order) => order.status == status).toList();
    }
    
    notifyListeners();
  }

  // Get orders by user
  Future<List<OrderModel>> getOrdersByUser(String userId) async {
    try {
      final querySnapshot = await _firebaseService.firestore
          .collection('orders')
          .where('userId', isEqualTo: userId)
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      _errorMessage = 'Failed to load user orders: $e';
      notifyListeners();
      return [];
    }
  }

  // Update order status
  Future<bool> updateOrderStatus(String orderId, OrderStatus newStatus) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final updateData = {
        'status': newStatus.name,
        'updatedAt': FieldValue.serverTimestamp(),
      };

      // If marking as delivered, set deliveredAt timestamp
      if (newStatus == OrderStatus.delivered) {
        updateData['deliveredAt'] = FieldValue.serverTimestamp();
      }

      await _firebaseService.updateDocument(
        collection: 'orders',
        docId: orderId,
        data: updateData,
      );
      
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          status: newStatus,
          lastUpdatedAt: DateTime.now(),
          deliveredAt: newStatus == OrderStatus.delivered ? DateTime.now() : null,
        );
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update order status: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Update payment status
  Future<bool> updatePaymentStatus(String orderId, PaymentStatus newStatus) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _firebaseService.updateDocument(
        collection: 'orders',
        docId: orderId,
        data: {
          'paymentStatus': newStatus.name,
          'updatedAt': FieldValue.serverTimestamp(),
        },
      );
      
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index != -1) {
        _orders[index] = _orders[index].copyWith(
          paymentStatus: newStatus,
          lastUpdatedAt: DateTime.now(),
        );
      }
      
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = 'Failed to update payment status: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  // Cancel order
  Future<bool> cancelOrder(String orderId) async {
    return await updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  // Get order by ID
  OrderModel? getOrderById(String orderId) {
    try {
      return _orders.firstWhere((o) => o.id == orderId);
    } catch (e) {
      return null;
    }
  }

  // Get orders by date range
  Future<List<OrderModel>> getOrdersByDateRange(DateTime start, DateTime end) async {
    try {
      final querySnapshot = await _firebaseService.firestore
          .collection('orders')
          .where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
          .where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(end))
          .orderBy('createdAt', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => OrderModel.fromFirestore(doc))
          .toList();
    } catch (e) {
      _errorMessage = 'Failed to load orders by date range: $e';
      notifyListeners();
      return [];
    }
  }

  // Get revenue statistics
  Map<String, double> getRevenueStatistics() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
    final startOfMonth = DateTime(today.year, today.month, 1);

    final todayOrders = _orders.where((o) => 
        o.createdAt.isAfter(startOfDay) && 
        o.status == OrderStatus.delivered);
    
    final weekOrders = _orders.where((o) => 
        o.createdAt.isAfter(startOfWeek) && 
        o.status == OrderStatus.delivered);
    
    final monthOrders = _orders.where((o) => 
        o.createdAt.isAfter(startOfMonth) && 
        o.status == OrderStatus.delivered);

    return {
      'today': todayOrders.fold(0.0, (sum, order) => sum + order.total),
      'week': weekOrders.fold(0.0, (sum, order) => sum + order.total),
      'month': monthOrders.fold(0.0, (sum, order) => sum + order.total),
      'total': totalRevenue,
    };
  }

  // Clear filter
  void clearFilter() {
    _statusFilter = null;
    _filteredOrders = [];
    notifyListeners();
  }

  // Clear error
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}