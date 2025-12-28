import 'package:flutter/material.dart';
import '../../../domain/entities/user_role.dart';

enum SidebarMode { expanded, rail, drawer }

class AdminSidebar extends StatelessWidget {
  final UserRole role;
  final SidebarMode mode;
  final ValueChanged<String> onNavigate;

  const AdminSidebar({
    super.key,
    required this.role,
    required this.mode,
    required this.onNavigate,
  });

  bool get canManageProducts =>
      role == UserRole.admin || role == UserRole.superAdmin;

  bool get canViewAudit =>
      role == UserRole.auditor || role == UserRole.superAdmin;

  @override
  Widget build(BuildContext context) {
    final tiles = <Widget>[
      ListTile(
        title: const Text('Dashboard'),
        onTap: () => onNavigate('/dashboard'),
      ),
      if (canManageProducts)
        ListTile(
          title: const Text('Products'),
          onTap: () => onNavigate('/products'),
        ),
      if (canViewAudit)
        ListTile(
          title: const Text('Audit'),
          onTap: () => onNavigate('/audit'),
        ),
    ];

    if (mode == SidebarMode.drawer) {
      return Drawer(child: ListView(children: tiles));
    }

    return Container(
      width: mode == SidebarMode.expanded ? 240 : 72,
      child: ListView(children: tiles),
    );
  }
}
