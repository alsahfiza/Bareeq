class ProductModel {
  final String id;
  final String nameAr;
  final double price;
  final String imageUrl;
  final String categoryId;
  final String description;
  final List sizes;

  ProductModel({
    required this.id,
    required this.nameAr,
    required this.price,
    required this.imageUrl,
    required this.categoryId,
    required this.description,
    required this.sizes,
  });

  factory ProductModel.fromMap(String id, Map<String, dynamic> map) {
    return ProductModel(
      id: id,
      nameAr: map['name_ar'] ?? '',
      price: map['price']?.toDouble() ?? 0,
      imageUrl: map['image_url'] ?? '',
      categoryId: map['category_id'] ?? '',
      description: map['description'] ?? '',
      sizes: map['sizes'] ?? [],
    );
  }
}
