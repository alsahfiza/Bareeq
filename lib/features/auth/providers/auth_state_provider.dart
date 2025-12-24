import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../core/config/auth_providers.dart';
import '../../../core/services/auth_service.dart';


sealed class AuthState {}
class AuthLoading extends AuthState {}
class AuthAuthenticated extends AuthState {
  final User user;
  AuthAuthenticated(this.user);
}
class AuthUnauthenticated extends AuthState {}

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  return AuthStateNotifier(ref);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final Ref ref;

  AuthStateNotifier(this.ref) : super(AuthLoading()) {
    _listen();
  }

  void _listen() {
    ref.read(authServiceProvider).authStateChanges().listen((user) {
      if (user == null) {
        state = AuthUnauthenticated();
      } else {
        state = AuthAuthenticated(user);
      }
    });
  }
}
