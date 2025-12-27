import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/audit_providers.dart';

class InventoryTableNotifier extends StateNotifier<void> {
  final Ref ref;

  InventoryTableNotifier(this.ref) : super(null);

  Future<void> adjustQuantity({
    required int oldQty,
    required int newQty,
  }) async {
    // existing inventory logic stays untouched

    await ref.read(auditLogServiceProvider).log(
      action: 'adjust_inventory',
      before: {'quantity': oldQty},
      after: {'quantity': newQty},
    );
  }
}
