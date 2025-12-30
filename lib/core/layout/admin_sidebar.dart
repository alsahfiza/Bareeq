import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/active_route_provider.dart';
import '../state/navigation_notifier.dart';
import '../state/sidebar_collapsed_provider.dart';
import '../routing/app_routes.dart';

class AdminSidebar extends ConsumerWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeRouteProvider);
    final collapsed = ref.watch(sidebarCollapsedProvider);

    return Container(
      width: collapsed ? 72 : 260,
      color: Colors.grey.shade900,
      child: Column(
        children: [
          _collapseButton(ref, collapsed),

          _navItem(
            context,
            ref,
            Icons.dashboard,
            'Dashboard',
            AppRoutes.dashboard,
            active,
            collapsed,
          ),
          _navItem(
            context,
            ref,
            Icons.shopping_bag,
            'Products',
            AppRoutes.products,
            active,
            collapsed,
          ),
          _navItem(
            context,
            ref,
            Icons.inventory,
            'Inventory',
            AppRoutes.inventory,
            active,
            collapsed,
          ),
          _navItem(
            context,
            ref,
            Icons.receipt_long,
            'Sales',
            AppRoutes.sales,
            active,
            collapsed,
          ),
          _navItem(
            context,
            ref,
            Icons.people,
            'Users',
            AppRoutes.users,
            active,
            collapsed,
          ),
          _navItem(
            context,
            ref,
            Icons.camera_alt,
            'Snapshots',
            AppRoutes.snapshots,
            active,
            collapsed,
          ),
          _navItem(
            context,
            ref,
            Icons.health_and_safety,
            'System Health',
            AppRoutes.systemHealth,
            active,
            collapsed,
          ),

          const Spacer(),

          _logoutItem(context, ref, collapsed),
        ],
      ),
    );
  }

  Widget _collapseButton(WidgetRef ref, bool collapsed) {
    return IconButton(
      icon: Icon(
        collapsed ? Icons.chevron_right : Icons.chevron_left,
        color: Colors.white,
      ),
      onPressed: () {
        ref.read(sidebarCollapsedProvider.notifier).state = !collapsed;
      },
    );
  }

  Widget _navItem(
    BuildContext context,
    WidgetRef ref,
    IconData icon,
    String title,
    String route,
    String active,
    bool collapsed,
  ) {
    final isActive = active == route;

    return ListTile(
      leading: Icon(icon, color: isActive ? Colors.white : Colors.grey),
      title: collapsed
          ? null
          : Text(
              title,
              style: TextStyle(
                color: isActive ? Colors.white : Colors.grey,
                fontWeight:
                    isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
      tileColor: isActive ? Colors.blueGrey : Colors.transparent,
      onTap: () => NavigationNotifier.go(context, ref, route),
    );
  }

  Widget _logoutItem(
    BuildContext context,
    WidgetRef ref,
    bool collapsed,
  ) {
    return ListTile(
      leading: const Icon(Icons.logout, color: Colors.redAccent),
      title: collapsed
          ? null
          : const Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
      onTap: () => NavigationNotifier.logout(context, ref),
    );
  }
}
