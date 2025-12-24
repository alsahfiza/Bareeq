import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/firestore/user_firestore_datasource.dart';
import '../models/user_model.dart';

class UserRepositoryImpl implements UserRepository {
  final UserFirestoreDatasource datasource;

  UserRepositoryImpl(this.datasource);

  @override
  Future<List<UserEntity>> getUsers() async {
    final models = await datasource.getUsers();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> createUser(UserEntity user) async {
    final model = UserModel.fromEntity(user);
    await datasource.createUser(model);
  }

  @override
  Future<void> updateUser(UserEntity user) async {
    final model = UserModel.fromEntity(user);
    await datasource.updateUser(user.id, model);
  }
}
