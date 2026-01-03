class ProductModel {
  final String id;
  String name;
  String sku;
  String barcode;
  String category;
  String brand;
  double costPrice;
  double sellingPrice;
  int quantity;
  int lowStock;
  bool active;
  String description;

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
}


class ProductInventory {
  static final List<ProductModel> products = [];

  static void addProduct(ProductModel product) {
    products.insert(0, product);
  }
}
