import '../../entities/audit_log_entity.dart';
import '../../repositories/audit_log_repository.dart';

class LogAction {
  final AuditLogRepository repository;

  LogAction(this.repository);

  Future<void> call(AuditLogEntity log) {
    return repository.log(log);
  }
}
