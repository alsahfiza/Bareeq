import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

class UpdateUser {
  final UserRepository repository;

  UpdateUser(this.repository);

  Future<void> call(UserEntity user) {
    return repository.updateUser(user);
  }
}
