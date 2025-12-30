import '../../../domain/entities/product_entity.dart';

class ProductsState {
  final bool loading;
  final List<ProductEntity> products;
  final String? error;

  const ProductsState({
    required this.loading,
    required this.products,
    this.error,
  });

  factory ProductsState.initial() {
    return const ProductsState(
      loading: false,
      products: [],
      error: null,
    );
  }

  ProductsState copyWith({
    bool? loading,
    List<ProductEntity>? products,
    String? error,
  }) {
    return ProductsState(
      loading: loading ?? this.loading,
      products: products ?? this.products,
      error: error,
    );
  }
}
