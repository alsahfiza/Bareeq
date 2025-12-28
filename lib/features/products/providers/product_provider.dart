import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../core/config/usecase_providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/firestore/product_firestore_datasource.dart';
import '../../data/repositories_impl/product_repository_impl.dart';
import '../../domain/usecases/products/get_products.dart';
import '../../domain/usecases/products/save_product.dart';

sealed class ProductsState {}
class ProductsLoading extends ProductsState {}
class ProductsReady extends ProductsState {
  final List<ProductEntity> products;
  ProductsReady(this.products);
}
class ProductsError extends ProductsState {
  final String message;
  ProductsError(this.message);
}

final productRepositoryProvider = Provider(
  (ref) => ProductRepositoryImpl(
    ProductFirestoreDatasource(FirebaseFirestore.instance),
  ),
);

final getProductsProvider =
    Provider((ref) => GetProducts(ref.read(productRepositoryProvider)));

final saveProductProvider =
    Provider((ref) => SaveProduct(ref.read(productRepositoryProvider)));


class ProductsNotifier extends StateNotifier<ProductsState> {
  final Ref ref;

  ProductsNotifier(this.ref) : super(ProductsLoading()) {
    load();
  }

  Future<void> load() async {
    try {
      final products = await ref.read(getProductsProvider).call();
      state = ProductsReady(products);
    } catch (e) {
      state = ProductsError(e.toString());
    }
  }
}
