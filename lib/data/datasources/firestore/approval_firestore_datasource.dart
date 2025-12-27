import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/approval_request_model.dart';

class ApprovalFirestoreDatasource {
  final FirebaseFirestore firestore;

  ApprovalFirestoreDatasource(this.firestore);

  Future<void> create(ApprovalRequestModel model) async {
    await firestore
        .collection('approvals')
        .doc(model.id)
        .set(model.toMap());
  }

  Future<List<ApprovalRequestModel>> getPending() async {
    final snap = await firestore
        .collection('approvals')
        .where('status', isEqualTo: 'pending')
        .get();

    return snap.docs
        .map((d) => ApprovalRequestModel.fromFirestore(d))
        .toList();
  }

  Future<void> update(ApprovalRequestModel model) async {
    await firestore
        .collection('approvals')
        .doc(model.id)
        .set(model.toMap(), SetOptions(merge: true));
  }
}
