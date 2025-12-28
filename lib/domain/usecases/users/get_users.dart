import '../../entities/user_entity.dart';
import '../../repositories/user_repository.dart';

class GetUsers {
  final UserRepository repo;
  GetUsers(this.repo);

  Future<List<UserEntity>> call() => repo.getUsers();
}
