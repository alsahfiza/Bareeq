import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/product_entity.dart';

final productsTableProvider =
    StateNotifierProvider<ProductsTableNotifier, ProductsTableState>(
  (ref) => ProductsTableNotifier(),
);

class ProductsTableNotifier extends StateNotifier<ProductsTableState> {
  ProductsTableNotifier() : super(ProductsTableState.empty());

  void search(String _) {}

  void prevPage() {}

  void nextPage() {}
}

class ProductsTableState {
  final bool loading;
  final List<ProductEntity> visible;

  const ProductsTableState({
    required this.loading,
    required this.visible,
  });

  factory ProductsTableState.empty() =>
      const ProductsTableState(loading: false, visible: []);
}
