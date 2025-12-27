import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/firestore/user_firestore_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserFirestoreDatasource datasource;

  UserRepositoryImpl(this.datasource);

  @override
  Future<List<UserEntity>> getUsers() async {
    final models = await datasource.getAllUsers();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<UserEntity> getCurrentUser() async {
    final firebaseUser = FirebaseAuth.instance.currentUser!;
    final model = await datasource.getUser(firebaseUser.uid);
    return model.toEntity();
  }

  @override
  Future<void> createUser(UserEntity user) async {
    final model = UserModel.fromEntity(user);
    await datasource.saveUser(model);
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final model = UserModel.fromEntity(user);
    await datasource.saveUser(model);
  }
}
