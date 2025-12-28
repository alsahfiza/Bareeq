import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

class CreateUser {
  final UserRepository repo;
  CreateUser(this.repo);

  Future<void> call(UserEntity user) => repo.saveUser(user);
}
