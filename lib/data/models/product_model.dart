class ProductModel {
  final String id;
  final String name;
  final String sku;
  final String barcode;
  final String category;
  final String brand;
  final double costPrice;
  final double sellingPrice;
  final int quantity;
  final int lowStock;
  final bool active;
  final String description;

  ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.barcode,
    required this.category,
    required this.brand,
    required this.costPrice,
    required this.sellingPrice,
    required this.quantity,
    required this.lowStock,
    required this.active,
    required this.description,
  });

  ProductModel copyWith({
    String? name,
    String? sku,
    String? barcode,
    String? category,
    String? brand,
    double? costPrice,
    double? sellingPrice,
    int? quantity,
    int? lowStock,
    bool? active,
    String? description,
  }) {
    return ProductModel(
      id: id,
      name: name ?? this.name,
      sku: sku ?? this.sku,
      barcode: barcode ?? this.barcode,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      costPrice: costPrice ?? this.costPrice,
      sellingPrice: sellingPrice ?? this.sellingPrice,
      quantity: quantity ?? this.quantity,
      lowStock: lowStock ?? this.lowStock,
      active: active ?? this.active,
      description: description ?? this.description,
    );
  }
}