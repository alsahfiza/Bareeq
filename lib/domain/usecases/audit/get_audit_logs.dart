import '../../entities/audit_log_entity.dart';
import '../../repositories/audit_log_repository.dart';

class GetAuditLogs {
  final AuditLogRepository repository;

  GetAuditLogs(this.repository);

  Future<List<AuditLogEntity>> call() {
    return repository.getLogs(entity: '*');
  }
}
