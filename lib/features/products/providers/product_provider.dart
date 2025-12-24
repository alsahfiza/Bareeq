import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../core/config/usecase_providers.dart';

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

final productsProvider =
    StateNotifierProvider<ProductsNotifier, ProductsState>((ref) {
  return ProductsNotifier(ref);
});

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
