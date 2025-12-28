import 'package:flutter/material.dart';
import '../../../domain/entities/user_role.dart';
import 'admin_sidebar.dart';

class AdminShell extends StatefulWidget {
  final Widget child;

  const AdminShell({super.key, required this.child});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  final UserRole role = UserRole.admin;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final mode = width < 600
        ? SidebarMode.drawer
        : width < 1000
            ? SidebarMode.rail
            : SidebarMode.expanded;

    return Scaffold(
      drawer: mode == SidebarMode.drawer
          ? AdminSidebar(
              role: role,
              mode: mode,
              onNavigate: _go,
            )
          : null,
      body: Row(
        children: [
          if (mode != SidebarMode.drawer)
            AdminSidebar(
              role: role,
              mode: mode,
              onNavigate: _go,
            ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  void _go(String route) {
    Navigator.of(context).pushNamed(route);
  }
}
