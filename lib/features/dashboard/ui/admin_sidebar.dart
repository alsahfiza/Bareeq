import 'package:flutter/material.dart';
import 'sidebar_item.dart';

class AdminSidebar extends StatelessWidget {
  final VoidCallback? onNavigate;

  const AdminSidebar({
    super.key,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey.shade100,
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(12),
          children: [
            const Text(
              'Bareeq Admin',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            SidebarItem(
              icon: Icons.dashboard,
              title: 'Dashboard',
              route: '/dashboard',
              onNavigate: onNavigate,
            ),
            SidebarItem(
              icon: Icons.inventory_2,
              title: 'Products',
              route: '/products',
              onNavigate: onNavigate,
            ),
            SidebarItem(
              icon: Icons.store,
              title: 'Inventory',
              route: '/inventory',
              onNavigate: onNavigate,
            ),
            SidebarItem(
              icon: Icons.receipt_long,
              title: 'Sales',
              route: '/sales',
              onNavigate: onNavigate,
            ),
            SidebarItem(
              icon: Icons.people,
              title: 'Users',
              route: '/users',
              onNavigate: onNavigate,
            ),
            SidebarItem(
              icon: Icons.settings,
              title: 'Settings',
              route: '/settings',
              onNavigate: onNavigate,
            ),
          ],
        ),
      ),
    );
  }
}
