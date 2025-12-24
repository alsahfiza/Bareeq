import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/users/get_users.dart';
import '../../domain/usecases/users/create_user.dart';
import '../../domain/usecases/users/update_user.dart';
import 'repository_providers.dart';

final getUsersProvider = Provider<GetUsers>((ref) {
  return GetUsers(ref.read(userRepositoryProvider));
});

final createUserProvider = Provider<CreateUser>((ref) {
  return CreateUser(ref.read(userRepositoryProvider));
});

final updateUserProvider = Provider<UpdateUser>((ref) {
  return UpdateUser(ref.read(userRepositoryProvider));
});
