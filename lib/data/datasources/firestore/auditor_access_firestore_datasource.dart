import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/auditor_access_model.dart';

class AuditorAccessFirestoreDatasource {
  final FirebaseFirestore firestore;

  AuditorAccessFirestoreDatasource(this.firestore);

  Future<AuditorAccessModel?> get(String userId) async {
    final doc =
        await firestore.collection('auditor_access').doc(userId).get();
    if (!doc.exists) return null;
    return AuditorAccessModel.fromFirestore(doc);
  }

  Future<void> grant(AuditorAccessModel model) async {
    await firestore
        .collection('auditor_access')
        .doc(model.userId)
        .set(model.toMap());
  }

  Future<void> revoke(String userId) async {
    await firestore.collection('auditor_access').doc(userId).delete();
  }
}
