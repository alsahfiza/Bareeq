class DashboardKpiEntity {
  final double totalSales;
  final double totalRevenue;
  final double totalProfit;
  final int lowStockCount;

  final double salesTrend;
  final double revenueTrend;
  final double profitTrend;

  const DashboardKpiEntity({
    required this.totalSales,
    required this.totalRevenue,
    required this.totalProfit,
    required this.lowStockCount,
    required this.salesTrend,
    required this.revenueTrend,
    required this.profitTrend,
  });
}
