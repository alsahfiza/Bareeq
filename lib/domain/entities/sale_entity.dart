class SaleEntity {
  final String id;
  final String productId;
  final int quantity;
  final double total;
  final double profit;
  final DateTime createdAt;

  const SaleEntity({
    required this.id,
    required this.productId,
    required this.quantity,
    required this.total,
    required this.profit,
    required this.createdAt,
  });
}
