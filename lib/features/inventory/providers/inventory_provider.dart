import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'inventory_notifier.dart';
import 'inventory_state.dart';

final inventoryProvider =
    StateNotifierProvider<InventoryNotifier, InventoryState>(
  (ref) => InventoryNotifier(),
);
