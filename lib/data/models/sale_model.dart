import '../../domain/entities/sale_entity.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SaleModel {
  final String id;
  final String productId;
  final int quantity;
  final double total;
  final double profit;
  final DateTime createdAt;

  SaleModel({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.total,
    required this.profit,
    required this.createdAt,
  });

  factory SaleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SaleModel(
      id: doc.id,
      productId: data['productId'],
      quantity: data['quantity'],
      total: data['total'],
      profit: data['profit'],
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  SaleEntity toEntity() {
    return SaleEntity(
      id: id,
      productId: productId,
      quantity: quantity,
      total: total,
      profit: profit,
      createdAt: createdAt,
    );
  }
}
