class UserAuditSummary {
  final String userId;
  final int actions;

  const UserAuditSummary({
    required this.userId,
    required this.actions,
  });
}

class EntityAuditSummary {
  final String entity;
  final int actions;

  const EntityAuditSummary({
    required this.entity,
    required this.actions,
  });
}

class DailyAuditSummary {
  final String day;
  final int actions;

  const DailyAuditSummary({
    required this.day,
    required this.actions,
  });
}
