import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../core/config/usecase_providers.dart';

class ProductsTableState {
  final List<ProductEntity> all;
  final List<ProductEntity> visible;
  final int page;
  final int pageSize;
  final String query;

  const ProductsTableState({
    required this.all,
    required this.visible,
    required this.page,
    required this.pageSize,
    required this.query,
  });

  ProductsTableState copyWith({
    List<ProductEntity>? all,
    List<ProductEntity>? visible,
    int? page,
    int? pageSize,
    String? query,
  }) {
    return ProductsTableState(
      all: all ?? this.all,
      visible: visible ?? this.visible,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      query: query ?? this.query,
    );
  }
}

final productsTableProvider =
    StateNotifierProvider<ProductsTableNotifier, ProductsTableState>((ref) {
  return ProductsTableNotifier(ref);
});

class ProductsTableNotifier extends StateNotifier<ProductsTableState> {
  final Ref ref;

  ProductsTableNotifier(this.ref)
      : super(const ProductsTableState(
          all: [],
          visible: [],
          page: 0,
          pageSize: 10,
          query: '',
        )) {
    _load();
  }

  Future<void> _load() async {
    final products = await ref.read(getProductsProvider).call();
    state = state.copyWith(all: products);
    _apply();
  }

  void search(String query) {
    state = state.copyWith(query: query, page: 0);
    _apply();
  }

  void nextPage() {
    state = state.copyWith(page: state.page + 1);
    _apply();
  }

  void prevPage() {
    if (state.page == 0) return;
    state = state.copyWith(page: state.page - 1);
    _apply();
  }

  void _apply() {
    final filtered = state.query.isEmpty
        ? state.all
        : state.all.where((p) {
            final q = state.query.toLowerCase();
            return p.name.toLowerCase().contains(q) ||
                p.sku.toLowerCase().contains(q);
          }).toList();

    final start = state.page * state.pageSize;
    final end = (start + state.pageSize).clamp(0, filtered.length);

    state = state.copyWith(
      visible: filtered.sublist(
        start,
        end,
      ),
    );
  }
}
