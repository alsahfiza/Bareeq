import '../../domain/entities/audit_log_entity.dart';
import '../../domain/usecases/audit/log_action.dart';

class AuditLogService {
  final LogAction _logAction;
  final String performedBy;

  AuditLogService({
    required LogAction logAction,
    required this.performedBy,
  }) : _logAction = logAction;

  Future<void> log({
    required String action,
    required String entity,
    required String entityId,
    required Map<String, dynamic> before,
    required Map<String, dynamic> after,
  }) async {
    final log = AuditLogEntity(
      action: action,
      entity: entity,
      entityId: entityId,
      performedBy: performedBy,
      before: before,
      after: after,
      timestamp: DateTime.now(),
    );

    await _logAction.call(log);
  }
}
