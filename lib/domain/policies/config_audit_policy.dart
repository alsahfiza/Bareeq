import '../entities/audit_log_entity.dart';

class ConfigAuditPolicy {
  static bool isConfigChange(AuditLogEntity log) {
    return log.entity == 'system_config' ||
        log.entity == 'settings' ||
        log.action.contains('config');
  }
}
