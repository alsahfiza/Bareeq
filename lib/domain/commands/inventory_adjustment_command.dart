import '../entities/inventory_adjustment_reason.dart';

class InventoryAdjustmentCommand {
  final String productId;
  final String storeId;
  final int delta;
  final InventoryAdjustmentReason reason;
  final String? comment;

  const InventoryAdjustmentCommand({
    required this.productId,
    required this.storeId,
    required this.delta,
    required this.reason,
    this.comment,
  });
}
