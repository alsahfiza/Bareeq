class OrderModel {
  final String id;
  final String userId;
  final List<OrderItem> items;
  final double total;
  final String status;
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.total,
    required this.status,
    required this.createdAt,
  });

  factory OrderModel.fromMap(String id, Map<String, dynamic> data) {
    return OrderModel(
      id: id,
      userId: data['userId'],
      total: (data['total'] as num).toDouble(),
      status: data['status'],
      createdAt: DateTime.parse(data['createdAt']),
      items: (data['items'] as List)
          .map((e) => OrderItem.fromMap(e))
          .toList(),
    );
  }
}

class OrderItem {
  final String productId;
  final String name;
  final int qty;
  final double price;

  OrderItem({
    required this.productId,
    required this.name,
    required this.qty,
    required this.price,
  });

  factory OrderItem.fromMap(Map<String, dynamic> data) {
    return OrderItem(
      productId: data['productId'],
      name: data['name'],
      qty: data['qty'],
      price: (data['price'] as num).toDouble(),
    );
  }
}
