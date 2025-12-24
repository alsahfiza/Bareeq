import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/audit_log_model.dart';

class AuditFirestoreDatasource {
  final FirebaseFirestore _firestore;

  AuditFirestoreDatasource(this._firestore);

  Future<void> log(AuditLogModel log) async {
    await _firestore.collection('audit_logs').add(log.toFirestore());
  }

  Future<List<AuditLogModel>> getLogs({
    required String entity,
  }) async {
    final snapshot = await _firestore
        .collection('audit_logs')
        .where('entity', isEqualTo: entity)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((d) => AuditLogModel.fromFirestore(d))
        .toList();
  }
}
