import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/approval_request_entity.dart';

class ApprovalRequestModel {
  final String id;
  final String actionType;
  final String entityType;
  final String entityId;
  final Map<String, dynamic> payload;
  final String requestedBy;
  final DateTime requestedAt;
  final String status;
  final String? reviewedBy;
  final DateTime? reviewedAt;
  final String? reviewComment;

  ApprovalRequestModel({
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

  factory ApprovalRequestModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return ApprovalRequestModel(
      id: doc.id,
      actionType: data['actionType'],
      entityType: data['entityType'],
      entityId: data['entityId'],
      payload: Map<String, dynamic>.from(data['payload']),
      requestedBy: data['requestedBy'],
      requestedAt: (data['requestedAt'] as Timestamp).toDate(),
      status: data['status'],
      reviewedBy: data['reviewedBy'],
      reviewedAt: data['reviewedAt'] == null
          ? null
          : (data['reviewedAt'] as Timestamp).toDate(),
      reviewComment: data['reviewComment'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'actionType': actionType,
      'entityType': entityType,
      'entityId': entityId,
      'payload': payload,
      'requestedBy': requestedBy,
      'requestedAt': requestedAt,
      'status': status,
      'reviewedBy': reviewedBy,
      'reviewedAt': reviewedAt,
      'reviewComment': reviewComment,
    };
  }

  ApprovalRequestEntity toEntity() {
    return ApprovalRequestEntity(
      id: id,
      actionType: actionType,
      entityType: entityType,
      entityId: entityId,
      payload: payload,
      requestedBy: requestedBy,
      requestedAt: requestedAt,
      status: ApprovalStatus.values
          .firstWhere((e) => e.name == status),
      reviewedBy: reviewedBy,
      reviewedAt: reviewedAt,
      reviewComment: reviewComment,
    );
  }

  static ApprovalRequestModel fromEntity(ApprovalRequestEntity e) {
    return ApprovalRequestModel(
      id: e.id,
      actionType: e.actionType,
      entityType: e.entityType,
      entityId: e.entityId,
      payload: e.payload,
      requestedBy: e.requestedBy,
      requestedAt: e.requestedAt,
      status: e.status.name,
      reviewedBy: e.reviewedBy,
      reviewedAt: e.reviewedAt,
      reviewComment: e.reviewComment,
    );
  }
}
