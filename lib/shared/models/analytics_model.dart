class SalesAnalytics {
  final double totalRevenue;
  final int totalOrders;
  final double todayRevenue;
  final Map<String, int> topProducts;

  SalesAnalytics({
    required this.totalRevenue,
    required this.totalOrders,
    required this.todayRevenue,
    required this.topProducts,
  });
}
