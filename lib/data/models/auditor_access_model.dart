import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/auditor_access_entity.dart';

class AuditorAccessModel {
  final String userId;
  final DateTime grantedAt;
  final DateTime? expiresAt;
  final String grantedBy;

  AuditorAccessModel({
    required this.userId,
    required this.grantedAt,
    required this.grantedBy,
    this.expiresAt,
  });

  factory AuditorAccessModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return AuditorAccessModel(
      userId: doc.id,
      grantedAt: (d['grantedAt'] as Timestamp).toDate(),
      expiresAt: d['expiresAt'] == null
          ? null
          : (d['expiresAt'] as Timestamp).toDate(),
      grantedBy: d['grantedBy'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'grantedAt': grantedAt,
      'expiresAt': expiresAt,
      'grantedBy': grantedBy,
    };
  }

  AuditorAccessEntity toEntity() {
    return AuditorAccessEntity(
      userId: userId,
      grantedAt: grantedAt,
      expiresAt: expiresAt,
      grantedBy: grantedBy,
    );
  }

  static AuditorAccessModel fromEntity(AuditorAccessEntity e) {
    return AuditorAccessModel(
      userId: e.userId,
      grantedAt: e.grantedAt,
      expiresAt: e.expiresAt,
      grantedBy: e.grantedBy,
    );
  }
}
