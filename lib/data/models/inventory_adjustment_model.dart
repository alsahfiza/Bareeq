import 'package:cloud_firestore/cloud_firestore.dart';

class InventoryAdjustmentModel {
  static Map<String, dynamic> create({
    required String productId,
    required int delta,
    required int before,
    required int after,
  }) {
    return {
      'productId': productId,
      'delta': delta,
      'before': before,
      'after': after,
      'createdAt': Timestamp.now(),
    };
  }
}
