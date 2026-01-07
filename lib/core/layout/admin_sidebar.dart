import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../state/active_route_provider.dart';
import '../state/sidebar_collapsed_provider.dart';
import '../routing/app_routes.dart';
import '../../features/auth/providers/auth_provider.dart';

class AdminSidebar extends ConsumerWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final activeRoute = ref.watch(activeRouteProvider);
    final collapsed = ref.watch(sidebarCollapsedProvider);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      width: collapsed ? 72 : 240,
      color: Colors.grey.shade900,
      child: Column(
        children: [
          const SizedBox(height: 8),

          // Collapse toggle
          ListTile(
            leading: Icon(
              collapsed ? Icons.menu : Icons.menu_open,
              color: Colors.white,
            ),
            title: collapsed
                ? null
                : const Text(
                    'Collapse',
                    style: TextStyle(color: Colors.white),
                  ),
            onTap: () {
              ref.read(sidebarCollapsedProvider.notifier).state = !collapsed;
            },
          ),

          _navItem(
            context,
            ref,
            Icons.dashboard,
            'Dashboard',
            AppRoutes.adminDashboard,
            activeRoute,
            collapsed,
          ),
          _navItem(
            context,
            ref,
            Icons.shopping_bag,
            'Products',
            AppRoutes.adminProducts,
            activeRoute,
            collapsed,
          ),
          _navItem(
            context,
            ref,
            Icons.receipt_long,
            'Sales',
            AppRoutes.adminSales,
            activeRoute,
            collapsed,
          ),
          _navItem(
            context,
            ref,
            Icons.people,
            'Users',
            AppRoutes.adminUsers,
            activeRoute,
            collapsed,
          ),

          const Spacer(),
          Divider(color: Colors.grey.shade700),

          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: collapsed
                ? null
                : const Text(
                    'Logout',
                    style: TextStyle(color: Colors.white),
                  ),
            onTap: () async {
              await ref.read(authProvider.notifier).logout();

              if (!context.mounted) return;

              Navigator.of(context).pushNamedAndRemoveUntil(
                AppRoutes.login,
                (_) => false,
              );
            },
          ),
        ],
      ),
    );
  }

  // ================= NAV ITEM =================
  Widget _navItem(
    BuildContext context,
    WidgetRef ref,
    IconData icon,
    String title,
    String route,
    String activeRoute,
    bool collapsed,
  ) {
    final isActive = activeRoute == route;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isActive ? Colors.blueGrey.shade800 : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Colors.white : Colors.grey.shade400,
          size: 22,
        ),
        title: collapsed
            ? null
            : Text(
                title,
                style: TextStyle(
                  color:
                      isActive ? Colors.white : Colors.grey.shade300,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
        minLeadingWidth: 0,
        horizontalTitleGap: 12,
        contentPadding: EdgeInsets.symmetric(
          horizontal: collapsed ? 0 : 12,
        ),
        onTap: isActive
            ? null
            : () {
                // 🔑 PRE-SET route to avoid double rebuild
                ref.read(activeRouteProvider.notifier).state = route;

                Navigator.of(context).pushReplacementNamed(route);
              },
      ),
    );
  }
}
