class CartItem {
  final String productId;
  final String name;
  final double price;
  final int qty;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    required this.qty,
  });

  factory CartItem.fromMap(Map<String, dynamic> data) {
    return CartItem(
      productId: data['productId'],
      name: data['name'],
      price: (data['price'] as num).toDouble(),
      qty: data['qty'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'name': name,
      'price': price,
      'qty': qty,
    };
  }
}
