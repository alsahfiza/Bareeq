import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/data_snapshot_model.dart';

class DataSnapshotFirestoreDatasource {
  final FirebaseFirestore firestore;

  DataSnapshotFirestoreDatasource(this.firestore);

  Future<void> create(DataSnapshotModel model) async {
    await firestore
        .collection('data_snapshots')
        .doc(model.id)
        .set(model.toMap());
  }

  Future<List<DataSnapshotModel>> getByType(String type) async {
    final snap = await firestore
        .collection('data_snapshots')
        .where('type', isEqualTo: type)
        .orderBy('createdAt', descending: true)
        .get();

    return snap.docs
        .map((d) => DataSnapshotModel.fromFirestore(d))
        .toList();
  }
}
