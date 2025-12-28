import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/inventory_entity.dart';

class InventoryModel {
  final String productId;
  final int quantity;
  final Timestamp updatedAt;

  InventoryModel({
    required this.productId,
    required this.quantity,
    required this.updatedAt,
  });

  factory InventoryModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return InventoryModel(
      productId: doc.id,
      quantity: d['quantity'] ?? 0,
      updatedAt: d['updatedAt'] ?? Timestamp.now(),
    );
  }

  InventoryEntity toEntity() => InventoryEntity(
        productId: productId,
        quantity: quantity,
        updatedAt: updatedAt.toDate(),
      );
}
