import '../entities/inventory_adjustment_reason.dart';

class InventoryAdjustmentPolicy {
  /// Absolute quantity delta that requires a comment
  static const int highImpactThreshold = 20;

  static bool requiresComment(int delta) {
    return delta.abs() >= highImpactThreshold;
  }

  static bool isValidReason(InventoryAdjustmentReason reason) {
    return InventoryAdjustmentReason.values.contains(reason);
  }
}
