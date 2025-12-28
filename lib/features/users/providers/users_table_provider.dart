import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_entity.dart';

final usersTableProvider =
    StateNotifierProvider<UsersTableNotifier, UsersTableState>(
  (ref) => UsersTableNotifier(),
);

class UsersTableNotifier extends StateNotifier<UsersTableState> {
  UsersTableNotifier() : super(UsersTableState.empty());

  void toggleActive(UserEntity u) {}
}

class UsersTableState {
  final bool loading;
  final List<UserEntity> users;

  const UsersTableState({
    required this.loading,
    required this.users,
  });

  factory UsersTableState.empty() =>
      const UsersTableState(loading: false, users: []);
}
