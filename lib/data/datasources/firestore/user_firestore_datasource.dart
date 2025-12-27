import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class UserFirestoreDatasource {
  final FirebaseFirestore firestore;

  UserFirestoreDatasource(this.firestore);

  Future<List<UserModel>> getAllUsers() async {
    final snapshot = await firestore.collection('users').get();
    return snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  Future<UserModel> getUser(String id) async {
    final doc = await firestore.collection('users').doc(id).get();
    return UserModel.fromFirestore(doc.data()!, doc.id);
  }

  Future<void> saveUser(UserModel model) async {
    await firestore
        .collection('users')
        .doc(model.id)
        .set(model.toFirestore(), SetOptions(merge: true));
  }
}
