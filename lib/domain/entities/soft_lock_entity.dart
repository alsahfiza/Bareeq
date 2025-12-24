class SoftLockEntity {
  final String entityType;
  final String entityId;
  final String lockedBy;
  final DateTime expiresAt;

  const SoftLockEntity({
    required this.entityType,
    required this.entityId,
    required this.lockedBy,
    required this.expiresAt,
  });

  bool get isExpired => DateTime.now().isAfter(expiresAt);
}
