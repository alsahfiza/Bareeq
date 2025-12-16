import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../admin/admin_app.dart';
import '../../customer/customer_app.dart';

class RoleGuard extends StatelessWidget {
  final User user;
  final VoidCallback onLanguageToggle;

  const RoleGuard({
    super.key,
    required this.user,
    required this.onLanguageToggle,
  });

  @override
  Widget build(BuildContext context) {
    return CustomerApp(onLanguageToggle: onLanguageToggle);
  }
}
