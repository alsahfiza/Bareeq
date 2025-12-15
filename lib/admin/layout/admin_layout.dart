import 'package:flutter/material.dart';
import 'package:flutter_admin_scaffold/admin_scaffold.dart';
import '../../shared/services/auth_service.dart';

class AdminLayout extends StatelessWidget {
  final Widget body;
  final String title;

  const AdminLayout({
    super.key,
    required this.body,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    final auth = AuthService();

    return AdminScaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await auth.logout();
            },
          ),
        ],
      ),
      sideBar: SideBar(
        selectedRoute:
            ModalRoute.of(context)?.settings.name,
        onSelected: (item) {
          if (item.route != null) {
            Navigator.pushNamed(context, item.route!);
          }
        },
        items: const [
          AdminMenuItem(
              title: 'Dashboard',
              route: '/dashboard',
              icon: Icons.dashboard),
          AdminMenuItem(title: 'Products', route: '/products'),
          AdminMenuItem(title: 'Categories', route: '/categories'),
          AdminMenuItem(title: 'Orders', route: '/orders'),
          AdminMenuItem(title: 'Analytics', route: '/analytics'),
          AdminMenuItem(title: 'Banners', route: '/banners'),
          AdminMenuItem(title: 'Users', route: '/users'),
          AdminMenuItem(title: 'Settings', route: '/settings'),
        ],
      ),
      body: body,
    );
  }
}
