import '../entities/product_entity.dart';

abstract class ProductRepository {
  Future<List<ProductEntity>> getProducts();
  Future<void> createProduct(ProductEntity product);
  Future<void> updateProduct(ProductEntity product);
}
