class AuditorAccessEntity {
  final String userId;
  final DateTime grantedAt;
  final DateTime? expiresAt;
  final String grantedBy;

  const AuditorAccessEntity({
    required this.userId,
    required this.grantedAt,
    required this.grantedBy,
    this.expiresAt,
  });

  bool get isExpired =>
      expiresAt != null && DateTime.now().isAfter(expiresAt!);
}
