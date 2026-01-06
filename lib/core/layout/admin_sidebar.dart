import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/active_route_provider.dart';
import '../state/sidebar_collapsed_provider.dart';
import '../state/navigation_notifier.dart';
import '../routing/app_routes.dart';

class AdminSidebar extends ConsumerWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final active = ref.watch(activeRouteProvider);
    final collapsed = ref.watch(sidebarCollapsedProvider);

    return Container(
      color: Colors.grey.shade900,
      child: Column(
        children: [
          const SizedBox(height: 8),
          ListTile(
            leading: Icon(
              collapsed ? Icons.menu : Icons.menu_open,
              color: Colors.white,
            ),
            title: collapsed ? null : const Text(
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
          const Spacer(),
          Divider(color: Colors.grey.shade700),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: collapsed ? null : const Text('Logout', style: TextStyle(color: Colors.white)),
            onTap: () => NavigationNotifier.logout(context, ref),
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
                  color: isActive
                      ? Colors.white
                      : Colors.grey.shade300,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
              ),
        minLeadingWidth: 0,
        horizontalTitleGap: 12,
        contentPadding: EdgeInsets.symmetric(
          horizontal: collapsed ? 0 : 12,
        ),
        onTap: () => NavigationNotifier.go(context, ref, route),
      ),
    );
  }
}