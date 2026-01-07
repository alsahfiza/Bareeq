import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

enum AuthStatus {
  unauthenticated,
  authenticated,
}

class AuthState {
  final AuthStatus status;

  const AuthState(this.status);

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>(
  (ref) => AuthStateNotifier(),
);

class AuthStateNotifier extends StateNotifier<AuthState> {
  AuthStateNotifier() : super(const AuthState(AuthStatus.unauthenticated)) {
    FirebaseAuth.instance.authStateChanges().listen((user) {
      state = user == null
          ? const AuthState(AuthStatus.unauthenticated)
          : const AuthState(AuthStatus.authenticated);
    });
  }
}