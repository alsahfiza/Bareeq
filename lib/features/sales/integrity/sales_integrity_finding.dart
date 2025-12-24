class SalesIntegrityFinding {
  final String saleId;
  final String productId;
  final int quantity;
  final double profit;
  final String issue;

  const SalesIntegrityFinding({
    required this.saleId,
    required this.productId,
    required this.quantity,
    required this.profit,
    required this.issue,
  });
}
