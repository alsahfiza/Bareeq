import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    final current = GoRouter.of(context).state.uri.toString();

    Widget item(String label, IconData icon, String route) {
      final bool active = current.startsWith(route);

      return InkWell(
        onTap: () => context.go(route),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
          decoration: BoxDecoration(
            color: active ? Colors.blue.shade50 : Colors.transparent,
            border: active
                ? Border(
                    right: BorderSide(width: 3, color: Colors.blue.shade700))
                : null,
          ),
          child: Row(
            children: [
              Icon(icon,
                  color: active ? Colors.blue.shade700 : Colors.grey.shade700),
              const SizedBox(width: 16),
              Text(
                label,
                style: TextStyle(
                  color:
                      active ? Colors.blue.shade700 : Colors.grey.shade800,
                  fontWeight: active ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 40),
          const Text(
            "ADMIN MENU",
            style: TextStyle(
                fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 20),

          item("Dashboard", Icons.dashboard, "/admin/dashboard"),
          item("Products", Icons.inventory_2, "/admin/products"),
          item("Categories", Icons.category, "/admin/categories"),
          item("Orders", Icons.receipt_long, "/admin/orders"),

          const Spacer(),

          item("Logout", Icons.logout, "/admin/login"),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
