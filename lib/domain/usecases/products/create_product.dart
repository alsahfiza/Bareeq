import '../../entities/product_entity.dart';
import '../../repositories/product_repository.dart';

class CreateProduct {
  final ProductRepository repository;

  CreateProduct(this.repository);

  Future<void> call(ProductEntity product) async {
    if (product.price < 0) {
      throw Exception('Price cannot be negative');
    }

    if (product.cost < 0) {
      throw Exception('Cost cannot be negative');
    }

    await repository.createProduct(product);
  }
}
