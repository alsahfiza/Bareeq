class UserActivityItem {
  final DateTime timestamp;
  final String action;
  final String entity;
  final String entityId;
  final Map<String, dynamic> before;
  final Map<String, dynamic> after;

  const UserActivityItem({
    required this.timestamp,
    required this.action,
    required this.entity,
    required this.entityId,
    required this.before,
    required this.after,
  });
}
