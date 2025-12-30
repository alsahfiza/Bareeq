import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'inventory_state.dart';
import '../../../domain/entities/inventory_entity.dart';

class InventoryNotifier extends StateNotifier<InventoryState> {
  InventoryNotifier() : super(InventoryState.initial()) {
    _loadStub();
  }

  Future<void> _loadStub() async {
    state = state.copyWith(loading: true);

    await Future.delayed(const Duration(milliseconds: 400));

    state = state.copyWith(
      loading: false,
      items: const [
        InventoryEntity(
          id: '1',
          productName: 'Detergent',
          quantity: 120,
          minStock: 50,
          inStock: true,
        ),
        InventoryEntity(
          id: '2',
          productName: 'Plastic Cups',
          quantity: 30,
          minStock: 40,
          inStock: false,
        ),
        InventoryEntity(
          id: '3',
          productName: 'Paper Towels',
          quantity: 200,
          minStock: 100,
          inStock: true,
        ),
      ],
    );
  }
}
