import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../core/config/user_providers.dart';
import '../../../core/config/audit_providers.dart';

class UsersTableState {
  final List<UserEntity> users;
  final bool loading;

  const UsersTableState({
    required this.users,
    required this.loading,
  });

  UsersTableState copyWith({
    List<UserEntity>? users,
    bool? loading,
  }) {
    return UsersTableState(
      users: users ?? this.users,
      loading: loading ?? this.loading,
    );
  }
}

final usersTableProvider =
    StateNotifierProvider<UsersTableNotifier, UsersTableState>((ref) {
  return UsersTableNotifier(ref);
});

class UsersTableNotifier extends StateNotifier<UsersTableState> {
  final Ref ref;

  UsersTableNotifier(this.ref)
      : super(const UsersTableState(users: [], loading: true)) {
    _load();
  }

  Future<void> _load() async {
    final users = await ref.read(getUsersProvider).call();
    state = state.copyWith(users: users, loading: false);
  }

  Future<void> toggleActive(UserEntity user) async {
    final updated = user.copyWith(isActive: !user.isActive);
    await ref.read(updateUserProvider).call(updated);

    await ref.read(auditLogServiceProvider).log(
      action: 'UPDATE',
      entity: 'user',
      entityId: user.id,
      before: {'isActive': user.isActive},
      after: {'isActive': updated.isActive},
    );

    await _load();
  }
}
