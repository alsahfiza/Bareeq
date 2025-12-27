import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/auth_state_provider.dart';
import 'login_page.dart';

class AuthGate extends ConsumerWidget {
  final Widget child;

  const AuthGate({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    switch (authState) {
      case AuthLoading():
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );

      case AuthUnauthenticated():
        return const LoginPage();

      case AuthAuthenticated():
        return child;
    }
  }
}
