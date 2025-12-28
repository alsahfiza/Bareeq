class SaleEntity {
  final String id;
  final double total;
  final double profit;
  final DateTime createdAt;

  const SaleEntity({
    required this.id,
    required this.total,
    required this.profit,
    required this.createdAt,
  });
}
