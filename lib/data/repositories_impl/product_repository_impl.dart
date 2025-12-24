import '../../domain/entities/product_entity.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/firestore/product_firestore_datasource.dart';
import '../models/product_model.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductFirestoreDatasource datasource;

  ProductRepositoryImpl(this.datasource);

  @override
  Future<List<ProductEntity>> getProducts() async {
    final models = await datasource.getProducts();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> createProduct(ProductEntity product) async {
    final model = ProductModel(
      id: product.id,
      name: product.name,
      sku: product.sku,
      barcode: product.barcode,
      category: product.category,
      price: product.price,
      cost: product.cost,
      isActive: product.isActive,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );

    await datasource.createProduct(model);
  }

  @override
  Future<void> updateProduct(ProductEntity product) async {
    final model = ProductModel(
      id: product.id,
      name: product.name,
      sku: product.sku,
      barcode: product.barcode,
      category: product.category,
      price: product.price,
      cost: product.cost,
      isActive: product.isActive,
      createdAt: product.createdAt,
      updatedAt: product.updatedAt,
    );

    await datasource.updateProduct(product.id, model);
  }
}
