class ProductInventoryIntelligence {
  final String productId;
  final String productName;
  final Map<String, int> stockByStore;
  final int totalStock;
  final StockSeverity severity;

  const ProductInventoryIntelligence({
    required this.productId,
    required this.productName,
    required this.stockByStore,
    required this.totalStock,
    required this.severity,
  });
}

enum StockSeverity {
  ok,
  warning,
  critical,
}
