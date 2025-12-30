import '../../../domain/entities/user_entity.dart';

class UsersState {
  final bool loading;
  final List<UserEntity> users;

  const UsersState({
    required this.loading,
    required this.users,
  });

  factory UsersState.initial() {
    return const UsersState(
      loading: false,
      users: [],
    );
  }

  UsersState copyWith({
    bool? loading,
    List<UserEntity>? users,
  }) {
    return UsersState(
      loading: loading ?? this.loading,
      users: users ?? this.users,
    );
  }
}
