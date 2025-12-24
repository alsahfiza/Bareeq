import '../../commands/inventory_adjustment_command.dart';
import '../../policies/inventory_adjustment_policy.dart';
import '../../repositories/inventory_repository.dart';

class AdjustInventoryWithSafeguards {
  final InventoryRepository repository;

  AdjustInventoryWithSafeguards(this.repository);

  Future<void> call(InventoryAdjustmentCommand cmd) async {
    if (!InventoryAdjustmentPolicy.isValidReason(cmd.reason)) {
      throw Exception('Invalid adjustment reason');
    }

    if (InventoryAdjustmentPolicy.requiresComment(cmd.delta) &&
        (cmd.comment == null || cmd.comment!.trim().isEmpty)) {
      throw Exception('Comment required for high-impact adjustment');
    }

    await repository.adjustInventory(
      productId: cmd.productId,
      storeId: cmd.storeId,
      delta: cmd.delta,
      metadata: {
        'reason': cmd.reason.name,
        'comment': cmd.comment,
      },
    );
  }
}
