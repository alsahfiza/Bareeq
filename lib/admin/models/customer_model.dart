import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final double totalSpent;
  final int loyaltyPoints;
  final DateTime createdAt;
  final DateTime? lastPurchaseAt;
  final List<String> purchaseHistory; // Order IDs
  final bool isActive;

  CustomerModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    this.totalSpent = 0.0,
    this.loyaltyPoints = 0,
    DateTime? createdAt,
    this.lastPurchaseAt,
    this.purchaseHistory = const [],
    this.isActive = true,
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to Firestore document
  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'totalSpent': totalSpent,
      'loyaltyPoints': loyaltyPoints,
      'createdAt': createdAt,
      'lastPurchaseAt': lastPurchaseAt,
      'purchaseHistory': purchaseHistory,
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
      email: data['email'] ?? '',
      totalSpent: (data['totalSpent'] ?? 0).toDouble(),
      loyaltyPoints: data['loyaltyPoints'] ?? 0,
      createdAt: data['createdAt'] != null
          ? (data['createdAt'] as Timestamp).toDate()
          : DateTime.now(),
      lastPurchaseAt: data['lastPurchaseAt'] != null
          ? (data['lastPurchaseAt'] as Timestamp).toDate()
          : null,
      purchaseHistory: List<String>.from(data['purchaseHistory'] ?? []),
      isActive: data['isActive'] ?? true,
    );
  }

  // Copy with changes
  CustomerModel copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    double? totalSpent,
    int? loyaltyPoints,
    DateTime? createdAt,
    DateTime? lastPurchaseAt,
    List<String>? purchaseHistory,
    bool? isActive,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      totalSpent: totalSpent ?? this.totalSpent,
      loyaltyPoints: loyaltyPoints ?? this.loyaltyPoints,
      createdAt: createdAt ?? this.createdAt,
      lastPurchaseAt: lastPurchaseAt ?? this.lastPurchaseAt,
      purchaseHistory: purchaseHistory ?? this.purchaseHistory,
      isActive: isActive ?? this.isActive,
    );
  }

  // Loyalty Points Calculation
  // 1 point per 10 SAR spent
  static int calculatePoints(double amount) {
    return (amount / 10).floor();
  }

  // Convert points to discount
  // 100 points = 50 SAR discount
  static double pointsToDiscount(int points) {
    return (points / 2).toDouble();
  }

  // Check if customer qualifies for tier benefits
  CustomerTier getTier() {
    if (totalSpent >= 5000) {
      return CustomerTier.platinum;
    } else if (totalSpent >= 2000) {
      return CustomerTier.gold;
    } else if (totalSpent >= 500) {
      return CustomerTier.silver;
    }
    return CustomerTier.bronze;
  }

  // Get tier bonus multiplier for points
  double getTierMultiplier() {
    switch (getTier()) {
      case CustomerTier.platinum:
        return 2.0; // 2x points
      case CustomerTier.gold:
        return 1.5; // 1.5x points
      case CustomerTier.silver:
        return 1.25; // 1.25x points
      case CustomerTier.bronze:
        return 1.0; // 1x points
    }
  }

  // Format customer info for display
  @override
  String toString() {
    return 'CustomerModel(id: $id, name: $name, phone: $phone, totalSpent: $totalSpent, loyaltyPoints: $loyaltyPoints)';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomerModel &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          phone == other.phone;

  @override
  int get hashCode => id.hashCode ^ phone.hashCode;
}

// Customer Tier Enum
enum CustomerTier {
  bronze,   // < 500 SAR
  silver,   // 500 - 1999 SAR
  gold,     // 2000 - 4999 SAR
  platinum, // >= 5000 SAR
}

extension CustomerTierExtension on CustomerTier {
  String get displayName {
    switch (this) {
      case CustomerTier.platinum:
        return 'Platinum';
      case CustomerTier.gold:
        return 'Gold';
      case CustomerTier.silver:
        return 'Silver';
      case CustomerTier.bronze:
        return 'Bronze';
    }
  }

  String get description {
    switch (this) {
      case CustomerTier.platinum:
        return 'Total spent >= 5000 SAR • 2x points';
      case CustomerTier.gold:
        return 'Total spent >= 2000 SAR • 1.5x points';
      case CustomerTier.silver:
        return 'Total spent >= 500 SAR • 1.25x points';
      case CustomerTier.bronze:
        return 'New customer • 1x points';
    }
  }
}