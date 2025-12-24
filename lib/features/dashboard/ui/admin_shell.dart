import 'package:flutter/material.dart';
import 'admin_sidebar.dart';

class AdminShell extends StatelessWidget {
  final Widget child;

  const AdminShell({
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(),
          Expanded(child: child),
        ],
      ),
    );
  }
}