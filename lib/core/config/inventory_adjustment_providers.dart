import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/inventory/adjust_inventory_with_safeguards.dart';
import 'repository_providers.dart';

final adjustInventoryWithSafeguardsProvider =
    Provider<AdjustInventoryWithSafeguards>((ref) {
  return AdjustInventoryWithSafeguards(
    ref.read(inventoryRepositoryProvider),
  );
});
