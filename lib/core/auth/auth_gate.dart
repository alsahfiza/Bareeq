import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../admin/admin_app.dart';
import '../../customer/customer_app.dart';
import 'login_page.dart';
import 'role_guard.dart';

class AuthGate extends StatelessWidget {
  final VoidCallback onLanguageToggle;

  const AuthGate({
    super.key,
    required this.onLanguageToggle,
  });

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (_, snapshot) {
        if (!snapshot.hasData) {
          return LoginPage(onLanguageToggle: onLanguageToggle);
        }
        return RoleGuard(
          user: snapshot.data!,
          onLanguageToggle: onLanguageToggle,
        );
      },
    );
  }
}
