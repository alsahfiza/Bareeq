import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'products_state.dart';
import '../../../domain/entities/product_entity.dart';

class ProductsNotifier extends StateNotifier<ProductsState> {
  ProductsNotifier() : super(ProductsState.initial()) {
    _loadStub();
  }

  Future<void> _loadStub() async {
    state = state.copyWith(loading: true);

    await Future.delayed(const Duration(milliseconds: 400));

    state = state.copyWith(
      loading: false,
      products: const [
        ProductEntity(
          id: '1',
          name: 'Detergent',
          sku: 'DET-001',
          price: 12.5,
          isActive: true,
        ),
        ProductEntity(
          id: '2',
          name: 'Plastic Cups',
          sku: 'PLS-010',
          price: 8.0,
          isActive: true,
        ),
        ProductEntity(
          id: '3',
          name: 'Paper Towels',
          sku: 'PAP-004',
          price: 15.75,
          isActive: false,
        ),
      ],
    );
  }
}
