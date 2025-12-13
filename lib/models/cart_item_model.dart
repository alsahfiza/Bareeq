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
}
