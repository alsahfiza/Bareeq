import '../../../domain/entities/audit_log_entity.dart';

class AuditCsvExporter {
  static String export(List<AuditLogEntity> logs) {
    final buffer = StringBuffer();
    buffer.writeln(
      'timestamp,entity,entityId,action,performedBy,before,after',
    );

    for (final l in logs) {
      buffer.writeln(
        '${l.timestamp.toIso8601String()},'
        '${l.entity},'
        '${l.entityId},'
        '${l.action},'
        '${l.performedBy},'
        '"${l.before}",'
        '"${l.after}"',
      );
    }

    return buffer.toString();
  }
}
