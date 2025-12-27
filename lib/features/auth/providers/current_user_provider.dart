import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../core/config/usecase_providers.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/config/repository_providers.dart';
import '../../../domain/entities/user_entity.dart';
import 'auth_state_provider.dart';

sealed class CurrentUserState {}

class CurrentUserLoading extends CurrentUserState {}

class CurrentUserReady extends CurrentUserState {
  final UserEntity user;
  CurrentUserReady(this.user);
  }

class CurrentUserError extends CurrentUserState {}

final currentUserProvider = FutureProvider<UserEntity>((ref) async {
  final repo = ref.read(userRepositoryProvider);
  return repo.getCurrentUser();
});

class CurrentUserNotifier extends StateNotifier<CurrentUserState> {
  final Ref ref;

  CurrentUserNotifier(this.ref) : super(CurrentUserLoading()) {
    _resolve();
  }

  Future<void> _resolve() async {
    final authState = ref.read(authStateProvider);

    if (authState is! AuthAuthenticated) {
      state = CurrentUserError();
      return;
    }

    try {
      final users = await ref.read(getUsersProvider).call();
      final user = users.firstWhere(
        (u) => u.id == authState.user.uid,
      );
      state = CurrentUserReady(user);
    } catch (_) {
      state = CurrentUserError();
    }
  }
}
