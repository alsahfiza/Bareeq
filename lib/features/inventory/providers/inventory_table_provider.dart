import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/inventory_entity.dart';
import '../../../core/config/inventory_providers.dart';


final inventoryTableProvider =
    FutureProvider<List<InventoryEntity>>((ref) async {
  return ref.read(getInventoryProvider).call();
});

class InventoryTableNotifier
    extends StateNotifier<InventoryTableState> {
  InventoryTableNotifier() : super(InventoryTableState.empty());

  void adjust({required dynamic current, required int delta}) {}

  void prevPage() {}

  void nextPage() {}
}

class InventoryTableState {
  final List<dynamic> visible;

  const InventoryTableState({required this.visible});

  factory InventoryTableState.empty() =>
      const InventoryTableState(visible: []);
}
