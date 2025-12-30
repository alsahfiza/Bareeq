class ProductEntity {
  final String id;
  final String name;
  final String sku;
  final double price;
  final bool isActive;

  const ProductEntity({
    required this.id,
    required this.name,
    required this.sku,
    required this.price,
    required this.isActive,
  });
}
