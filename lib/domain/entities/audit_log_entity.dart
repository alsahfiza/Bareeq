class AuditLogEntity {
  final String action;
  final String entity;
  final String entityId;
  final String performedBy;
  final Map<String, dynamic> before;
  final Map<String, dynamic> after;
  final DateTime timestamp;

  const AuditLogEntity({
    required this.action,
    required this.entity,
    required this.entityId,
    required this.performedBy,
    required this.before,
    required this.after,
    required this.timestamp,
  });
}
