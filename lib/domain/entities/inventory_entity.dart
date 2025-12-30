class InventoryEntity {
  final String id;
  final String productName;
  final int quantity;
  final int minStock;
  final bool inStock;

  const InventoryEntity({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.minStock,
    required this.inStock,
  });
}
