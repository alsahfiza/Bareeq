class ProductModel {
  final String id;

  // Core
  final String name;
  final String description;
  final String sku;
  final String categoryId;

  // Pricing
  final double price;
  final double cost;
  final double discount;
  final double taxPercent;

  // Inventory
  final int stock;
  final int lowStockThreshold;
  final double weight;

  // Status
  final bool onSale;
  final bool isActive;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.sku,
    required this.categoryId,
    required this.price,
    required this.cost,
    required this.discount,
    required this.taxPercent,
    required this.stock,
    required this.lowStockThreshold,
    required this.weight,
    required this.onSale,
    required this.isActive,
  });

  factory ProductModel.fromMap(
      String id, Map<String, dynamic> data) {
    return ProductModel(
      id: id,
      name: data['name'],
      description: data['description'],
      sku: data['sku'],
      categoryId: data['categoryId'],
      price: (data['price'] as num).toDouble(),
      cost: (data['cost'] as num).toDouble(),
      discount: (data['discount'] as num).toDouble(),
      taxPercent: (data['taxPercent'] as num).toDouble(),
      stock: data['stock'],
      lowStockThreshold: data['lowStockThreshold'],
      weight: (data['weight'] as num).toDouble(),
      onSale: data['onSale'],
      isActive: data['isActive'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'sku': sku,
      'categoryId': categoryId,
      'price': price,
      'cost': cost,
      'discount': discount,
      'taxPercent': taxPercent,
      'stock': stock,
      'lowStockThreshold': lowStockThreshold,
      'weight': weight,
      'onSale': onSale,
      'isActive': isActive,
      'createdAt': DateTime.now(),
    };
  }
}
