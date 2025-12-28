import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/datasources/firestore/user_firestore_datasource.dart';
import '../../data/repositories_impl/user_repository_impl.dart';
import '../../domain/usecases/users/get_users.dart';
import '../../domain/usecases/users/create_user.dart';
import '../../domain/usecases/users/update_user.dart';

final userRepositoryProvider = Provider<UserRepositoryImpl>((ref) {
  return UserRepositoryImpl(); // NO args
});


final getUsersProvider =
    Provider((ref) => GetUsers(ref.read(userRepositoryProvider)));

final createUserProvider =
    Provider((ref) => CreateUser(ref.read(userRepositoryProvider)));

final updateUserProvider =
    Provider((ref) => UpdateUser(ref.read(userRepositoryProvider)));
