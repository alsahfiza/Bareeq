class InventoryRuleEntity {
  final String productId;
  final int minimumStock;

  const InventoryRuleEntity({
    required this.productId,
    required this.minimumStock,
  });
}
