import 'package:cloud_firestore/cloud_firestore.dart';

// ==================== CUSTOMER TIER ====================

enum CustomerTier {
  bronze,    // < 500 SAR
  silver,    // 500 - 1999 SAR
  gold,      // 2000 - 4999 SAR
  platinum,  // >= 5000 SAR
}

// ==================== CUSTOMER MODEL ====================

class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String? email;
  final String? address;
  final double totalSpent;
  final int loyaltyPoints;
  final int totalPurchases;
  final List<String>? purchaseHistory;
  final DateTime createdAt;
  final DateTime lastPurchaseDate;
  final bool isActive;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    this.email,
    this.address,
    this.totalSpent = 0,
    this.loyaltyPoints = 0,
    this.totalPurchases = 0,
    this.purchaseHistory,
    DateTime? createdAt,
    DateTime? lastPurchaseDate,
    this.isActive = true,
  })  : createdAt = createdAt ?? DateTime.now(),
        lastPurchaseDate = lastPurchaseDate ?? DateTime.now();

  // Get customer tier based on total spent
  CustomerTier get tier {
    if (totalSpent >= 5000) return CustomerTier.platinum;
    if (totalSpent >= 2000) return CustomerTier.gold;
    if (totalSpent >= 500) return CustomerTier.silver;
    return CustomerTier.bronze;
  }

  // Get tier name
  String getTierName() {
    switch (tier) {
      case CustomerTier.bronze:
        return 'Bronze';
      case CustomerTier.silver:
        return 'Silver';
      case CustomerTier.gold:
        return 'Gold';
      case CustomerTier.platinum:
        return 'Platinum';
    }
  }

  // Get points multiplier based on tier
  double getPointsMultiplier() {
    switch (tier) {
      case CustomerTier.bronze:
        return 1.0;
      case CustomerTier.silver:
        return 1.25;
      case CustomerTier.gold:
        return 1.5;
      case CustomerTier.platinum:
        return 2.0;
    }
  }

  // Calculate points from amount (1 point per 10 SAR spent)
  static int calculatePoints(double amount) {
    return (amount / 10).floor();
  }

  // Convert points to discount (100 points = 50 SAR)
  static double pointsToDiscount(int points) {
    return (points / 100) * 50;
  }

  // Add purchase
  CustomerModel addPurchase(double amount, String? orderId) {
    final newPoints = calculatePoints(amount);
    final multipliedPoints = (newPoints * getPointsMultiplier()).toInt();
    
    return CustomerModel(
      id: id,
      name: name,
      phone: phone,
      email: email,
      address: address,
      totalSpent: totalSpent + amount,
      loyaltyPoints: loyaltyPoints + multipliedPoints,
      totalPurchases: totalPurchases + 1,
      purchaseHistory: [
        ...?purchaseHistory,
        orderId ?? DateTime.now().toString(),
      ],
      createdAt: createdAt,
      lastPurchaseDate: DateTime.now(),
      isActive: isActive,
    );
  }

  // Redeem points
  CustomerModel redeemPoints(int points) {
    if (points > loyaltyPoints) {
      throw Exception('Insufficient points');
    }
    
    return copyWith(loyaltyPoints: loyaltyPoints - points);
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'totalSpent': totalSpent,
      'loyaltyPoints': loyaltyPoints,
      'totalPurchases': totalPurchases,
      'purchaseHistory': purchaseHistory,
      'createdAt': createdAt,
      'lastPurchaseDate': lastPurchaseDate,
      'isActive': isActive,
    };
  }
  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'totalSpent': totalSpent,
      'loyaltyPoints': loyaltyPoints,
      'totalPurchases': totalPurchases,
      'purchaseHistory': purchaseHistory,
      'createdAt': createdAt.toIso8601String(),
      'lastPurchaseDate': lastPurchaseDate.toIso8601String(),
      'isActive': isActive,
    };
  }


  // Create from Firestore document
  factory CustomerModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return CustomerModel(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      email: data['email'],
      address: data['address'],
      totalSpent: (data['totalSpent'] ?? 0).toDouble(),
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
      totalPurchases: data['totalPurchases'] ?? 0,
      purchaseHistory: List<String>.from(data['purchaseHistory'] ?? []),
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      lastPurchaseDate: data['lastPurchaseDate'] != null
          ? (data['lastPurchaseDate'] as Timestamp).toDate()
          : DateTime.now(),
      isActive: data['isActive'] ?? true,
    );
  }

  // Copy with changes
  CustomerModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    double? totalSpent,
    int? loyaltyPoints,
    int? totalPurchases,
    List<String>? purchaseHistory,
    DateTime? createdAt,
    DateTime? lastPurchaseDate,
    bool? isActive,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      totalSpent: totalSpent ?? this.totalSpent,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      purchaseHistory: purchaseHistory ?? this.purchaseHistory,
      createdAt: createdAt ?? this.createdAt,
      lastPurchaseDate: lastPurchaseDate ?? this.lastPurchaseDate,
      isActive: isActive ?? this.isActive,
    );
  }

  @override
  String toString() {
    return 'CustomerModel(id: $id, name: $name, phone: $phone, totalSpent: $totalSpent, tier: ${getTierName()})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}

// ==================== EXPENSE CATEGORY ENUM ====================

enum ExpenseCategory {
  rent,
  utilities,
  salaries,
  supplies,
  equipment,
  maintenance,
  marketing,
  insurance,
  taxes,
  transportation,
  other,
}

// ==================== PAYMENT METHOD ENUM ====================

enum PaymentMethod {
  cash,
  bankTransfer,
  creditCard,
  cheque,
  other,
}

// ==================== EXPENSE MODEL ====================

class ExpenseModel {
  final String id;
  final String description;
  final double amount;
  final ExpenseCategory category;
  final PaymentMethod paymentMethod;
  final DateTime date;
  final String? receiptUrl;
  final String? notes;
  final String addedBy;
  final String addedById;
  final DateTime createdAt;

  ExpenseModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.category,
    required this.paymentMethod,
    required this.date,
    this.receiptUrl,
    this.notes,
    required this.addedBy,
    required this.addedById,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  // Get category name
  String getCategoryName() {
    switch (category) {
      case ExpenseCategory.rent:
        return 'Rent';
      case ExpenseCategory.utilities:
        return 'Utilities';
      case ExpenseCategory.salaries:
        return 'Salaries';
      case ExpenseCategory.supplies:
        return 'Supplies';
      case ExpenseCategory.equipment:
        return 'Equipment';
      case ExpenseCategory.maintenance:
        return 'Maintenance';
      case ExpenseCategory.marketing:
        return 'Marketing';
      case ExpenseCategory.insurance:
        return 'Insurance';
      case ExpenseCategory.taxes:
        return 'Taxes';
      case ExpenseCategory.transportation:
        return 'Transportation';
      case ExpenseCategory.other:
        return 'Other';
    }
  }

  // Get payment method name
  String getPaymentMethodName() {
    switch (paymentMethod) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.bankTransfer:
        return 'Bank Transfer';
      case PaymentMethod.creditCard:
        return 'Credit Card';
      case PaymentMethod.cheque:
        return 'Cheque';
      case PaymentMethod.other:
        return 'Other';
    }
  }

  // Format date
  String getFormattedDate() {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'description': description,
      'amount': amount,
      'category': category.name,
      'paymentMethod': paymentMethod.name,
      'date': date,
      'receiptUrl': receiptUrl,
      'notes': notes,
      'addedBy': addedBy,
      'addedById': addedById,
      'createdAt': createdAt,
    };
  }

  // Create from Firestore document
  factory ExpenseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ExpenseModel(
      id: doc.id,
      description: data['description'] ?? '',
      amount: (data['amount'] ?? 0).toDouble(),
      category: _parseExpenseCategory(data['category']),
      paymentMethod: _parsePaymentMethod(data['paymentMethod']),
      date: data['date'] != null
          ? (data['date'] as Timestamp).toDate()
          : DateTime.now(),
      receiptUrl: data['receiptUrl'],
      notes: data['notes'],
      addedBy: data['addedBy'] ?? 'Unknown',
      addedById: data['addedById'] ?? '',
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
    );
  }

  // Helper to parse category
  static ExpenseCategory _parseExpenseCategory(String? category) {
    switch (category?.toLowerCase()) {
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

  // Helper to parse payment method
  static PaymentMethod _parsePaymentMethod(String? method) {
    switch (method?.toLowerCase()) {
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

  // Copy with changes
  ExpenseModel copyWith({
    String? id,
    String? description,
    double? amount,
    ExpenseCategory? category,
    PaymentMethod? paymentMethod,
    DateTime? date,
    String? receiptUrl,
    String? notes,
    String? addedBy,
    String? addedById,
    DateTime? createdAt,
  }) {
    return ExpenseModel(
      id: id ?? this.id,
      description: description ?? this.description,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      date: date ?? this.date,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      notes: notes ?? this.notes,
      addedBy: addedBy ?? this.addedBy,
      addedById: addedById ?? this.addedById,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'ExpenseModel(id: $id, description: $description, amount: $amount, category: ${getCategoryName()}, date: ${getFormattedDate()})';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ExpenseModel &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;
}