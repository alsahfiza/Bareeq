import 'package:cloud_firestore/cloud_firestore.dart';

// ==================== ENUMS ====================

enum OrderStatus {
  pending,
  processing,
  shipped,
  delivered,
  cancelled,
}

enum PaymentStatus {
  pending,
  completed,
  failed,
  refunded,
}

enum OrderPaymentMethod {
  cash,
  creditCard,
  debitCard,
  bankTransfer,
  mada,
  stcPay,
  applePay,
  googlePay,
}

// ==================== ORDER ITEM ====================

class OrderItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final double total;
  final String? imageUrl;

  OrderItem({
    required this.productId,
    required this.productName,
    required this.price,
    required this.quantity,
    required this.total,
    this.imageUrl,
  });

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'price': price,
      'quantity': quantity,
      'total': total,
      'imageUrl': imageUrl,
    };
  }

  // Create from map
  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      productId: map['productId'] ?? '',
      productName: map['productName'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      quantity: map['quantity'] ?? 1,
      total: (map['total'] ?? 0).toDouble(),
      imageUrl: map['imageUrl'],
    );
  }
}

// ==================== DELIVERY ADDRESS ====================

class DeliveryAddress {
  final String street;
  final String city;
  final String region;
  final String postalCode;
  final double? latitude;
  final double? longitude;
  final String? notes;

  DeliveryAddress({
    required this.street,
    required this.city,
    required this.region,
    required this.postalCode,
    this.latitude,
    this.longitude,
    this.notes,
  });

  // Convert to map
  Map<String, dynamic> toMap() {
    return {
      'street': street,
      'city': city,
      'region': region,
      'postalCode': postalCode,
      'latitude': latitude,
      'longitude': longitude,
      'notes': notes,
    };
  }

  // Create from map
  factory DeliveryAddress.fromMap(Map<String, dynamic> map) {
    return DeliveryAddress(
      street: map['street'] ?? '',
      city: map['city'] ?? '',
      region: map['region'] ?? '',
      postalCode: map['postalCode'] ?? '',
      latitude: map['latitude'],
      longitude: map['longitude'],
      notes: map['notes'],
    );
  }

  @override
  String toString() => '$street, $city, $region $postalCode';
}

// ==================== ORDER MODEL ====================

class OrderModel {
  final String id;
  final String customerId;
  final String? customerName;
  final String? customerPhone;
  final String? customerEmail;
  final List<OrderItem> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double shippingCost;
  final double total;
  final OrderStatus status;
  final PaymentStatus paymentStatus;
  final OrderPaymentMethod? paymentMethod;
  final DeliveryAddress? deliveryAddress;
  final DateTime createdAt;
  final DateTime? deliveredAt;
  final DateTime? lastUpdatedAt;
  final String? notes;
  final String? trackingNumber;

  OrderModel({
    required this.id,
    required this.customerId,
    this.customerName,
    this.customerPhone,
    this.customerEmail,
    required this.items,
    required this.subtotal,
    this.discount = 0,
    this.tax = 0,
    this.shippingCost = 0,
    required this.total,
    this.status = OrderStatus.pending,
    this.paymentStatus = PaymentStatus.pending,
    this.paymentMethod,
    this.deliveryAddress,
    DateTime? createdAt,
    this.deliveredAt,
    this.lastUpdatedAt,
    this.notes,
    this.trackingNumber,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'customerEmail': customerEmail,
      'items': items.map((item) => item.toMap()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'shippingCost': shippingCost,
      'total': total,
      'status': status.name,
      'paymentStatus': paymentStatus.name,
      'paymentMethod': paymentMethod?.name,
      'deliveryAddress': deliveryAddress?.toMap(),
      'createdAt': createdAt,
      'deliveredAt': deliveredAt,
      'lastUpdatedAt': lastUpdatedAt,
      'notes': notes,
      'trackingNumber': trackingNumber,
    };
  }

  // Create from Firestore document
  factory OrderModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return OrderModel(
      id: doc.id,
      customerId: data['customerId'] ?? '',
      customerName: data['customerName'],
      customerPhone: data['customerPhone'],
      customerEmail: data['customerEmail'],
      items: (data['items'] as List?)
              ?.map((item) => OrderItem.fromMap(item))
              .toList() ??
          [],
      subtotal: (data['subtotal'] ?? 0).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      tax: (data['tax'] ?? 0).toDouble(),
      shippingCost: (data['shippingCost'] ?? 0).toDouble(),
      total: (data['total'] ?? 0).toDouble(),
      status: _parseOrderStatus(data['status']),
      paymentStatus: _parsePaymentStatus(data['paymentStatus']),
      paymentMethod: _parsePaymentMethod(data['paymentMethod']),
      deliveryAddress: data['deliveryAddress'] != null
          ? DeliveryAddress.fromMap(data['deliveryAddress'])
          : null,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      deliveredAt: data['deliveredAt'] != null
          ? (data['deliveredAt'] as Timestamp).toDate()
          : null,
      lastUpdatedAt: data['lastUpdatedAt'] != null
          ? (data['lastUpdatedAt'] as Timestamp).toDate()
          : null,
      notes: data['notes'],
      trackingNumber: data['trackingNumber'],
    );
  }

  // Helper methods for parsing enums
  static OrderStatus _parseOrderStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return OrderStatus.pending;
      case 'processing':
        return OrderStatus.processing;
      case 'shipped':
        return OrderStatus.shipped;
      case 'delivered':
        return OrderStatus.delivered;
      case 'cancelled':
        return OrderStatus.cancelled;
      default:
        return OrderStatus.pending;
    }
  }

  static PaymentStatus _parsePaymentStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return PaymentStatus.pending;
      case 'completed':
        return PaymentStatus.completed;
      case 'failed':
        return PaymentStatus.failed;
      case 'refunded':
        return PaymentStatus.refunded;
      default:
        return PaymentStatus.pending;
    }
  }

  static OrderPaymentMethod? _parsePaymentMethod(String? method) {
    switch (method?.toLowerCase()) {
      case 'cash':
        return OrderPaymentMethod.cash;
      case 'creditcard':
        return OrderPaymentMethod.creditCard;
      case 'debitcard':
        return OrderPaymentMethod.debitCard;
      case 'banktransfer':
        return OrderPaymentMethod.bankTransfer;
      case 'mada':
        return OrderPaymentMethod.mada;
      case 'stcpay':
        return OrderPaymentMethod.stcPay;
      case 'applepay':
        return OrderPaymentMethod.applePay;
      case 'googlepay':
        return OrderPaymentMethod.googlePay;
      default:
        return null;
    }
  }

  // Copy with changes
  OrderModel copyWith({
    String? id,
    String? customerId,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    List<OrderItem>? items,
    double? subtotal,
    double? discount,
    double? tax,
    double? shippingCost,
    double? total,
    OrderStatus? status,
    PaymentStatus? paymentStatus,
    OrderPaymentMethod? paymentMethod,
    DeliveryAddress? deliveryAddress,
    DateTime? createdAt,
    DateTime? deliveredAt,
    DateTime? lastUpdatedAt,
    String? notes,
    String? trackingNumber,
  }) {
    return OrderModel(
      id: id ?? this.id,
      customerId: customerId ?? this.customerId,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      shippingCost: shippingCost ?? this.shippingCost,
      total: total ?? this.total,
      status: status ?? this.status,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      deliveryAddress: deliveryAddress ?? this.deliveryAddress,
      createdAt: createdAt ?? this.createdAt,
      deliveredAt: deliveredAt ?? this.deliveredAt,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
      notes: notes ?? this.notes,
      trackingNumber: trackingNumber ?? this.trackingNumber,
    );
  }

  // Get order status display name
  String getStatusDisplayName() {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.processing:
        return 'Processing';
      case OrderStatus.shipped:
        return 'Shipped';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  // Get payment status display name
  String getPaymentStatusDisplayName() {
    switch (paymentStatus) {
      case PaymentStatus.pending:
        return 'Pending';
      case PaymentStatus.completed:
        return 'Completed';
      case PaymentStatus.failed:
        return 'Failed';
      case PaymentStatus.refunded:
        return 'Refunded';
    }
  }

  @override
  String toString() {
    return 'OrderModel(id: $id, customerId: $customerId, total: $total, status: $status)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}