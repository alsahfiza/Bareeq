import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

class UpdateUser {
  final UserRepository repo;
  UpdateUser(this.repo);

  Future<void> call(UserEntity user) => repo.saveUser(user);
}
