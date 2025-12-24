class InventoryEntity {
  final String productId;
  final String storeId;
  final int quantity;
  final DateTime updatedAt;

  const InventoryEntity({
    required this.productId,
    required this.storeId,
    required this.quantity,
    required this.updatedAt,
  });
}
