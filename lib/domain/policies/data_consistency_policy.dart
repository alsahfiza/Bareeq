import '../entities/product_entity.dart';
import '../entities/inventory_entity.dart';
import '../entities/sale_entity.dart';

class DataConsistencyIssue {
  final String type;
  final String message;
  final String entityId;

  const DataConsistencyIssue({
    required this.type,
    required this.message,
    required this.entityId,
  });
}

class DataConsistencyPolicy {
  static List<DataConsistencyIssue> check({
    required List<ProductEntity> products,
    required List<InventoryEntity> inventory,
    required List<SaleEntity> sales,
  }) {
    final issues = <DataConsistencyIssue>[];

    final productIds = products.map((p) => p.id).toSet();
    final inventoryByProduct = <String, int>{};

    for (final i in inventory) {
      inventoryByProduct[i.productId] =
          (inventoryByProduct[i.productId] ?? 0) + i.quantity;

      if (i.quantity < 0) {
        issues.add(
          DataConsistencyIssue(
            type: 'NEGATIVE_INVENTORY',
            entityId: i.productId,
            message:
                'Inventory below zero for product ${i.productId}',
          ),
        );
      }

      if (!productIds.contains(i.productId)) {
        issues.add(
          DataConsistencyIssue(
            type: 'ORPHAN_INVENTORY',
            entityId: i.productId,
            message:
                'Inventory references missing product ${i.productId}',
          ),
        );
      }
    }

    for (final s in sales) {
      if (!inventoryByProduct.containsKey(s.productId)) {
        issues.add(
          DataConsistencyIssue(
            type: 'SALE_WITHOUT_INVENTORY',
            entityId: s.id,
            message:
                'Sale ${s.id} references product with no inventory',
          ),
        );
      }
    }

    for (final p in products) {
      if (p.categoryId == null || p.categoryId!.isEmpty) {
        issues.add(
          DataConsistencyIssue(
            type: 'PRODUCT_NO_CATEGORY',
            entityId: p.id,
            message:
                'Product ${p.id} has no category assigned',
          ),
        );
      }
    }

    return issues;
  }
}
