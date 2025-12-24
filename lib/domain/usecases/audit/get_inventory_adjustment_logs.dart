import '../../entities/audit_log_entity.dart';
import '../../repositories/audit_log_repository.dart';

class GetInventoryAdjustmentLogs {
  final AuditLogRepository repository;

  GetInventoryAdjustmentLogs(this.repository);

  Future<List<AuditLogEntity>> call() {
    return repository.getLogs(entity: 'inventory');
  }
}
