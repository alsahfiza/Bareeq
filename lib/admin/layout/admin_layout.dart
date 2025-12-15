import 'package:flutter/material.dart';
import '../widgets/admin_sidebar.dart';

class AdminLayout extends StatelessWidget {
  final Widget child;
  const AdminLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const AdminSidebar(), // ONLY SIDEBAR
          Expanded(
            child: Container(
              color: Colors.grey[100],
              padding: const EdgeInsets.all(24),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
