class InvoiceItem {
  final String name;
  final int qty;
  final double price;

  InvoiceItem({
    required this.name,
    required this.qty,
    required this.price,
  });
}

class InvoiceModel {
  final String orderId;
  final String userId;
  final List<InvoiceItem> items;
  final double subtotal;
  final double vatRate;
  final double vatAmount;
  final double deliveryFee;
  final double total;
  final String paymentMethod;
  final DateTime createdAt;

  InvoiceModel({
    required this.orderId,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.vatRate,
    required this.vatAmount,
    required this.deliveryFee,
    required this.total,
    required this.paymentMethod,
    required this.createdAt,
  });
}
