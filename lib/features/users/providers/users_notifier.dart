import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'users_state.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/user_role.dart';

class UsersNotifier extends StateNotifier<UsersState> {
  UsersNotifier() : super(UsersState.initial()) {
    _loadStub();
  }

  Future<void> _loadStub() async {
    state = state.copyWith(loading: true);

    await Future.delayed(const Duration(milliseconds: 400));

    state = state.copyWith(
      loading: false,
      users: List.generate(
        12,
        (i) => UserEntity(
          id: '$i',
          name: 'User ${i + 1}',
          email: 'user${i + 1}@bareeq.com',
          role: UserRole.values[i % UserRole.values.length],
          active: i % 3 != 0,
          createdAt: DateTime.now().subtract(Duration(days: i * 7)),
        ),
      ),
    );
  }

  void toggleActive(UserEntity user) {
    final updated = state.users
        .map((u) => u.id == user.id
            ? u.copyWith(active: !u.active)
            : u)
        .toList();

    state = state.copyWith(users: updated);
  }
}
