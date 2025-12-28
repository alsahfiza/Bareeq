class InventoryEntity {
  final String productId;
  final int quantity;
  final DateTime updatedAt;

  const InventoryEntity({
    required this.productId,
    required this.quantity,
    required this.updatedAt,
  });
}
