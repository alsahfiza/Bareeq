import 'package:flutter_riverpod/flutter_riverpod.dart';

final inventoryTableProvider =
    StateNotifierProvider<InventoryTableNotifier, InventoryTableState>(
  (ref) => InventoryTableNotifier(),
);

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
