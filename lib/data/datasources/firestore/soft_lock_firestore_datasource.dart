import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/soft_lock_model.dart';

class SoftLockFirestoreDatasource {
  final FirebaseFirestore firestore;

  SoftLockFirestoreDatasource(this.firestore);

  Future<SoftLockModel?> getLock(
    String entityType,
    String entityId,
  ) async {
    final doc = await firestore
        .collection('soft_locks')
        .doc('$entityType:$entityId')
        .get();

    if (!doc.exists) return null;
    return SoftLockModel.fromFirestore(doc);
  }

  Future<void> acquireLock(SoftLockModel model) async {
    await firestore
        .collection('soft_locks')
        .doc('${model.entityType}:${model.entityId}')
        .set(model.toFirestore());
  }
}
