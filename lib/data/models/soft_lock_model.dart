import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/soft_lock_entity.dart';

class SoftLockModel {
  final String entityType;
  final String entityId;
  final String lockedBy;
  final DateTime expiresAt;

  SoftLockModel({
    required this.entityType,
    required this.entityId,
    required this.lockedBy,
    required this.expiresAt,
  });

  factory SoftLockModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SoftLockModel(
      entityType: data['entityType'],
      entityId: data['entityId'],
      lockedBy: data['lockedBy'],
      expiresAt: (data['expiresAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'entityType': entityType,
      'entityId': entityId,
      'lockedBy': lockedBy,
      'expiresAt': expiresAt,
    };
  }

  SoftLockEntity toEntity() {
    return SoftLockEntity(
      entityType: entityType,
      entityId: entityId,
      lockedBy: lockedBy,
      expiresAt: expiresAt,
    );
  }

  static SoftLockModel fromEntity(SoftLockEntity e) {
    return SoftLockModel(
      entityType: e.entityType,
      entityId: e.entityId,
      lockedBy: e.lockedBy,
      expiresAt: e.expiresAt,
    );
  }
}
