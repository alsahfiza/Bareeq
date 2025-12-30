class SaleEntity {
  final String id;
  final String productName;
  final int quantity;
  final double price;
  final double cost;
  final DateTime date;

  const SaleEntity({
    required this.id,
    required this.productName,
    required this.quantity,
    required this.price,
    required this.cost,
    required this.date,
  });

  double get revenue => quantity * price;
  double get profit => quantity * (price - cost);
}
