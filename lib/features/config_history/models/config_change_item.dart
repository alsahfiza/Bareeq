class ConfigChangeItem {
  final DateTime timestamp;
  final String performedBy;
  final String action;
  final Map<String, dynamic> before;
  final Map<String, dynamic> after;

  const ConfigChangeItem({
    required this.timestamp,
    required this.performedBy,
    required this.action,
    required this.before,
    required this.after,
  });
}
