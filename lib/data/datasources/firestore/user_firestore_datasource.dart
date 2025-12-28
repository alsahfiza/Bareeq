import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class UserFirestoreDatasource {
  final FirebaseFirestore firestore;
  UserFirestoreDatasource(this.firestore);

  Future<List<UserModel>> getAll() async {
    final snap = await firestore.collection('users').get();
    return snap.docs.map(UserModel.fromFirestore).toList();
  }

  Future<void> save(UserModel model) async {
    await firestore.collection('users').doc(model.id).set(
          model.data,
          SetOptions(merge: true),
        );
  }
}
