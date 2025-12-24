import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/inventory_rule_entity.dart';

class InventoryRuleModel {
  final String productId;
  final int minimumStock;

  InventoryRuleModel({
    required this.productId,
    required this.minimumStock,
  });

  factory InventoryRuleModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return InventoryRuleModel(
      productId: doc.id,
      minimumStock: data['minimumStock'],
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'minimumStock': minimumStock,
    };
  }

  InventoryRuleEntity toEntity() {
    return InventoryRuleEntity(
      productId: productId,
      minimumStock: minimumStock,
    );
  }

  static InventoryRuleModel fromEntity(InventoryRuleEntity e) {
    return InventoryRuleModel(
      productId: e.productId,
      minimumStock: e.minimumStock,
    );
  }
}
