class CartItem {
  final String id;
  final String nameAr;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.nameAr,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });

  // ---- Total price of this item ----
  double get total => price * quantity;

  // ---- Convert Cart Item to Map (for Orders Firestore) ----
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "name_ar": nameAr,
      "image_url": imageUrl,
      "price": price,
      "quantity": quantity,
      "total": total,
    };
  }

  // ---- Create Cart Item from Firestore Map ----
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map["id"],
      nameAr: map["name_ar"],
      imageUrl: map["image_url"],
      price: (map["price"] as num).toDouble(),
      quantity: map["quantity"] ?? 1,
    );
  }

  // ---- Copy With (Useful for quantity updates) ----
  CartItem copyWith({
    String? id,
    String? nameAr,
    String? imageUrl,
    double? price,
    int? quantity,
  }) {
    return CartItem(
      id: id ?? this.id,
      nameAr: nameAr ?? this.nameAr,
      imageUrl: imageUrl ?? this.imageUrl,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
    );
  }
}
