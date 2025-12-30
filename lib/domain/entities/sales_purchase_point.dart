class SalesPurchasePoint {
  final String label; // e.g. 2am, 4am, Jan, Feb
  final double sales;
  final double purchase;

  const SalesPurchasePoint({
    required this.label,
    required this.sales,
    required this.purchase,
  });
}
