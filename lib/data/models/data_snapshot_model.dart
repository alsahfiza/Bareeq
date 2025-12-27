import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/data_snapshot_entity.dart';

class DataSnapshotModel {
  final String id;
  final String type;
  final DateTime createdAt;
  final String createdBy;
  final Map<String, dynamic> data;

  DataSnapshotModel({
    required this.id,
    required this.type,
    required this.createdAt,
    required this.createdBy,
    required this.data,
  });

  factory DataSnapshotModel.fromFirestore(DocumentSnapshot doc) {
    final d = doc.data() as Map<String, dynamic>;
    return DataSnapshotModel(
      id: doc.id,
      type: d['type'],
      createdAt: (d['createdAt'] as Timestamp).toDate(),
      createdBy: d['createdBy'],
      data: Map<String, dynamic>.from(d['data']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'createdAt': createdAt,
      'createdBy': createdBy,
      'data': data,
    };
  }

  DataSnapshotEntity toEntity() {
    return DataSnapshotEntity(
      id: id,
      type: SnapshotType.values.firstWhere((e) => e.name == type),
      createdAt: createdAt,
      createdBy: createdBy,
      data: data,
    );
  }

  static DataSnapshotModel fromEntity(DataSnapshotEntity e) {
    return DataSnapshotModel(
      id: e.id,
      type: e.type.name,
      createdAt: e.createdAt,
      createdBy: e.createdBy,
      data: e.data,
    );
  }
}
