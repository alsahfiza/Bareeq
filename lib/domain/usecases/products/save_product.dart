import '../../entities/product_entity.dart';
import '../../repositories/product_repository.dart';

class SaveProduct {
  final ProductRepository repo;
  SaveProduct(this.repo);

  Future<void> call(ProductEntity product) => repo.saveProduct(product);
}
