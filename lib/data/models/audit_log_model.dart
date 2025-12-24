import 'package:cloud_firestore/cloud_firestore.dart';

class AuditLogModel {
  final String action;
  final String entity;
  final String entityId;
  final String performedBy;
  final Map<String, dynamic> before;
  final Map<String, dynamic> after;
  final DateTime timestamp;

  AuditLogModel({
    required this.action,
    required this.entity,
    required this.entityId,
    required this.performedBy,
    required this.before,
    required this.after,
    required this.timestamp,
  });

  factory AuditLogModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AuditLogModel(
      action: data['action'],
      entity: data['entity'],
      entityId: data['entityId'],
      performedBy: data['performedBy'],
      before: Map<String, dynamic>.from(data['before']),
      after: Map<String, dynamic>.from(data['after']),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'action': action,
      'entity': entity,
      'entityId': entityId,
      'performedBy': performedBy,
      'before': before,
      'after': after,
      'timestamp': timestamp,
    };
  }
}
