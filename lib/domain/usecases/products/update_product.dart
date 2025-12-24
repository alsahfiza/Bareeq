import '../../entities/product_entity.dart';
import '../../repositories/product_repository.dart';

class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  Future<void> call(ProductEntity product) async {
    if (!product.isActive) {
      // Soft-disable only, never delete
      await repository.updateProduct(product);
      return;
    }

    if (product.price < product.cost) {
      throw Exception('Price cannot be lower than cost');
    }

    await repository.updateProduct(product);
  }
}
