import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final authProvider =
    StateNotifierProvider<AuthNotifier, void>((ref) {
  return AuthNotifier();
});

class AuthNotifier extends StateNotifier<void> {
  AuthNotifier() : super(null);

  Future<void> login(String email, String password) async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  Future<void> logout() async {
    await FirebaseAuth.instance.signOut();
  }
}