enum ApprovalStatus {
  pending,
  approved,
  rejected,
}

class ApprovalRequestEntity {
  final String id;
  final String actionType; // e.g. inventory_adjustment, price_change
  final String entityType; // product, inventory
  final String entityId;
  final Map<String, dynamic> payload; // proposed change
  final String requestedBy;
  final DateTime requestedAt;
  final ApprovalStatus status;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? reviewComment;

  const ApprovalRequestEntity({
    required this.id,
    required this.actionType,
    required this.entityType,
    required this.entityId,
    required this.payload,
    required this.requestedBy,
    required this.requestedAt,
    required this.status,
    this.reviewedBy,
    this.reviewedAt,
    this.reviewComment,
  });

  ApprovalRequestEntity copyWith({
    ApprovalStatus? status,
    String? reviewedBy,
    DateTime? reviewedAt,
    String? reviewComment,
  }) {
    return ApprovalRequestEntity(
      id: id,
      actionType: actionType,
      entityType: entityType,
      entityId: entityId,
      payload: payload,
      requestedBy: requestedBy,
      requestedAt: requestedAt,
      status: status ?? this.status,
      reviewedBy: reviewedBy ?? this.reviewedBy,
      reviewedAt: reviewedAt ?? this.reviewedAt,
      reviewComment: reviewComment ?? this.reviewComment,
    );
  }
}
