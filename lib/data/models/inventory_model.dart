import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/inventory_entity.dart';

class InventoryModel {
  final String productId;
  final String storeId;
  final int quantity;
  final DateTime updatedAt;

  InventoryModel({
    required this.productId,
    required this.storeId,
    required this.quantity,
    required this.updatedAt,
  });

  factory InventoryModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InventoryModel(
      productId: data['productId'],
      storeId: data['storeId'],
      quantity: data['quantity'],
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'productId': productId,
      'storeId': storeId,
      'quantity': quantity,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }

  InventoryEntity toEntity() => InventoryEntity(
        productId: productId,
        storeId: storeId,
        quantity: quantity,
        updatedAt: updatedAt,
      );
}
