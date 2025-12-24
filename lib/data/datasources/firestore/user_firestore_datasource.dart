import 'package:cloud_firestore/cloud_firestore.dart';
import '../../models/user_model.dart';

class UserFirestoreDatasource {
  final FirebaseFirestore _firestore;

  UserFirestoreDatasource(this._firestore);

  Future<List<UserModel>> getUsers() async {
    final snapshot = await _firestore.collection('users').get();

    return snapshot.docs
        .map((doc) => UserModel.fromFirestore(doc))
        .toList();
  }

  Future<void> createUser(UserModel user) async {
    await _firestore
        .collection('users')
        .doc(user.id)
        .set(user.toFirestore());
  }

  Future<void> updateUser(String userId, UserModel user) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .update(user.toFirestore());
  }
}
