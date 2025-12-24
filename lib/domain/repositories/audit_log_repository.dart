import '../entities/audit_log_entity.dart';

abstract class AuditLogRepository {
  Future<void> log(AuditLogEntity log);
  Future<List<AuditLogEntity>> getLogs({
    required String entity,
  });
}
