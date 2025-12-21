import 'package:cloud_firestore/cloud_firestore.dart';

// ==================== SALE MODEL (In-Store Transaction) ====================
class SaleModel {
  final String id;
  final String saleNumber; // e.g., "SALE-001"
  final List<SaleItem> items;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final PaymentMethod paymentMethod;
  final String? customerName; // Optional: for regular customers
  final String? customerPhone; // Optional
  final String cashierName; // Who made the sale
  final String cashierId; // Admin user ID who made the sale
  final DateTime saleDate;
  final String? notes;

  SaleModel({
    required this.id,
    required this.saleNumber,
    required this.items,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.paymentMethod,
    this.customerName,
    this.customerPhone,
    required this.cashierName,
    required this.cashierId,
    required this.saleDate,
    this.notes,
  });

  // Calculate totals
  static double calculateSubtotal(List<SaleItem> items) {
    return items.fold(0.0, (sum, item) => sum + item.total);
  }

  static double calculateTax(double subtotal, double taxRate) {
    return subtotal * (taxRate / 100);
  }

  static double calculateTotal(double subtotal, double discount, double tax) {
    return subtotal - discount + tax;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'saleNumber': saleNumber,
      'items': items.map((item) => item.toJson()).toList(),
      'subtotal': subtotal,
      'discount': discount,
      'tax': tax,
      'total': total,
      'paymentMethod': paymentMethod.name,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'cashierName': cashierName,
      'cashierId': cashierId,
      'saleDate': Timestamp.fromDate(saleDate),
      'notes': notes,
    };
  }

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    return SaleModel(
      id: json['id'] ?? '',
      saleNumber: json['saleNumber'] ?? '',
      items: (json['items'] as List?)
              ?.map((item) => SaleItem.fromJson(item as Map<String, dynamic>))
              .toList() ??
          [],
      subtotal: (json['subtotal'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      tax: (json['tax'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
      paymentMethod: PaymentMethod.values.firstWhere(
        (e) => e.name == json['paymentMethod'],
        orElse: () => PaymentMethod.cash,
      ),
      customerName: json['customerName'],
      customerPhone: json['customerPhone'],
      cashierName: json['cashierName'] ?? '',
      cashierId: json['cashierId'] ?? '',
      saleDate: json['saleDate'] is Timestamp
          ? (json['saleDate'] as Timestamp).toDate()
          : DateTime.now(),
      notes: json['notes'],
    );
  }

  factory SaleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SaleModel.fromJson({...data, 'id': doc.id});
  }

  SaleModel copyWith({
    String? id,
    String? saleNumber,
    List<SaleItem>? items,
    double? subtotal,
    double? discount,
    double? tax,
    double? total,
    PaymentMethod? paymentMethod,
    String? customerName,
    String? customerPhone,
    String? cashierName,
    String? cashierId,
    DateTime? saleDate,
    String? notes,
  }) {
    return SaleModel(
      id: id ?? this.id,
      saleNumber: saleNumber ?? this.saleNumber,
      items: items ?? this.items,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      cashierName: cashierName ?? this.cashierName,
      cashierId: cashierId ?? this.cashierId,
      saleDate: saleDate ?? this.saleDate,
      notes: notes ?? this.notes,
    );
  }
}

// ==================== SALE ITEM ====================
class SaleItem {
  final String productId;
  final String productName;
  final String? productImage;
  final String barcode; // For scanning products
  final int quantity;
  final double unitPrice;
  final double discount; // Discount per item
  final double total;

  SaleItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.barcode,
    required this.quantity,
    required this.unitPrice,
    this.discount = 0.0,
    required this.total,
  });

  // Calculate item total
  static double calculateItemTotal(int quantity, double unitPrice, double discount) {
    return (quantity * unitPrice) - discount;
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'productName': productName,
      'productImage': productImage,
      'barcode': barcode,
      'quantity': quantity,
      'unitPrice': unitPrice,
      'discount': discount,
      'total': total,
    };
  }

  factory SaleItem.fromJson(Map<String, dynamic> json) {
    return SaleItem(
      productId: json['productId'] ?? '',
      productName: json['productName'] ?? '',
      productImage: json['productImage'],
      barcode: json['barcode'] ?? '',
      quantity: json['quantity'] ?? 0,
      unitPrice: (json['unitPrice'] ?? 0).toDouble(),
      discount: (json['discount'] ?? 0).toDouble(),
      total: (json['total'] ?? 0).toDouble(),
    );
  }

  SaleItem copyWith({
    String? productId,
    String? productName,
    String? productImage,
    String? barcode,
    int? quantity,
    double? unitPrice,
    double? discount,
    double? total,
  }) {
    return SaleItem(
      productId: productId ?? this.productId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      barcode: barcode ?? this.barcode,
      quantity: quantity ?? this.quantity,
      unitPrice: unitPrice ?? this.unitPrice,
      discount: discount ?? this.discount,
      total: total ?? this.total,
    );
  }
}

// ==================== PAYMENT METHOD ENUM ====================
enum PaymentMethod {
  cash,
  card,
  bankTransfer,
  stcPay, // Saudi digital wallet
  mada, // Saudi debit card
}

// Extension for display names
extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.cash:
        return 'نقدي / Cash';
      case PaymentMethod.card:
        return 'بطاقة / Card';
      case PaymentMethod.bankTransfer:
        return 'تحويل بنكي / Bank Transfer';
      case PaymentMethod.stcPay:
        return 'STC Pay';
      case PaymentMethod.mada:
        return 'مدى / Mada';
    }
  }
}