import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../core/config/user_providers.dart';

class UsersTableNotifier extends StateNotifier<List<UserEntity>> {
  final Ref ref;

  UsersTableNotifier(this.ref) : super([]) {
    load();
  }

  Future<void> load() async {
    state = await ref.read(getUsersProvider).call();
  }

  Future<void> toggleActive(UserEntity user) async {
    final updated = user.copyWith(isActive: !user.isActive);
    await ref.read(updateUserProvider).call(updated);
    load();
  }
}

final usersTableProvider =
    StateNotifierProvider<UsersTableNotifier, List<UserEntity>>(
  (ref) => UsersTableNotifier(ref),
);
