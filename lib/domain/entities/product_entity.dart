class ProductEntity {
  final String id;
  final String name;
  final String sku;
  final String barcode;
  final String category;
  final double price;
  final double cost;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.category,
    required this.price,
    required this.cost,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
  });

  ProductEntity copyWith({
    String? name,
    String? sku,
    String? barcode,
    String? category,
    double? price,
    double? cost,
    bool? isActive,
    DateTime? updatedAt,
  }) {
    return ProductEntity(
      id: id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      price: price ?? this.price,
      cost: cost ?? this.cost,
      isActive: isActive ?? this.isActive,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
