class ProductModel {
  final String id;
  final String name;
  final double price;
  final double discount;
  final bool onSale;
  final int stock;
  final String categoryId;
  final bool isActive;

  ProductModel({
    required this.id,
    required this.name,
    required this.price,
    required this.discount,
    required this.onSale,
    required this.stock,
    required this.categoryId,
    required this.isActive,
  });

  factory ProductModel.fromMap(String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,
      name: data['name'],
      price: (data['price'] as num).toDouble(),
      discount: (data['discount'] ?? 0).toDouble(),
      onSale: data['onSale'] ?? false,
      stock: data['stock'] ?? 0,
      categoryId: data['categoryId'],
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'discount': discount,
      'onSale': onSale,
      'stock': stock,
      'categoryId': categoryId,
      'isActive': isActive,
      'createdAt': DateTime.now(),
    };
  }
}
