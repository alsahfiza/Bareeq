class DashboardKpi {
  final int productsCount;
  final int inventoryCount;
  final int salesCount;
  final double totalRevenue;
  final DateTime? lastProductUpdate;
  final DateTime? lastInventoryUpdate;
  final DateTime? lastSaleUpdate;

  const DashboardKpi({
    required this.productsCount,
    required this.inventoryCount,
    required this.salesCount,
    required this.totalRevenue,
    required this.lastProductUpdate,
    required this.lastInventoryUpdate,
    required this.lastSaleUpdate,
  });
}
