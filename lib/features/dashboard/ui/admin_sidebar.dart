import 'package:flutter/material.dart';
import '../../../domain/entities/user_role.dart';

class AdminSidebar extends StatelessWidget {
  final UserRole role;
  final ValueChanged<String> onNavigate;

  const AdminSidebar({
    super.key,
    required this.role,
    required this.onNavigate,
  });

  bool _canManageProducts() =>
      role == UserRole.admin || role == UserRole.superAdmin;

  bool _canViewAudit() =>
      role == UserRole.auditor || role == UserRole.superAdmin;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(child: Text('Bareeq Admin')),

          ListTile(
            title: const Text('Dashboard'),
            onTap: () => onNavigate('/dashboard'),
          ),

          if (_canManageProducts())
            ListTile(
              title: const Text('Products'),
              onTap: () => onNavigate('/products'),
            ),

          if (_canViewAudit())
            ListTile(
              title: const Text('Audit Logs'),
              onTap: () => onNavigate('/audit'),
            ),
        ],
      ),
    );
  }
}
