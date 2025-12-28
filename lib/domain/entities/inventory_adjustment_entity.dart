class InventoryAdjustmentEntity {
  final String productId;
  final int delta;
  final int before;
  final int after;
  final DateTime createdAt;

  const InventoryAdjustmentEntity({
    required this.productId,
    required this.delta,
    required this.before,
    required this.after,
    required this.createdAt,
  });
}
