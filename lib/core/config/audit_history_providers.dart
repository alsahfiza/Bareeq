import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/audit/get_inventory_adjustment_logs.dart';
import 'repository_providers.dart';

final getInventoryAdjustmentLogsProvider =
    Provider<GetInventoryAdjustmentLogs>((ref) {
  return GetInventoryAdjustmentLogs(
    ref.read(auditRepositoryProvider),
  );
});
