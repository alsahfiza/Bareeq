import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../routing/app_routes.dart';
import '../state/active_route_provider.dart';
import '../state/navigation_notifier.dart';
import '../state/sidebar_collapsed_provider.dart';

class AdminSidebar extends ConsumerWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsed = ref.watch(sidebarCollapsedProvider);
    final active = ref.watch(activeRouteProvider);

    return Container(
      color: const Color(0xFF111827),
      child: Column(
        children: [
          const SizedBox(height: 12),

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

          _logoutItem(context, ref, collapsed),

          const SizedBox(height: 12),
        ],
      ),
    );
  }

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
        ),
        title: collapsed
            ? null
            : Text(
                title,
                style: TextStyle(
                  color:
                      isActive ? Colors.white : Colors.grey.shade300,
                  fontWeight: FontWeight.w600,
                ),
              ),
        onTap: () => NavigationNotifier.go(context, ref, route),
      ),
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
              style: TextStyle(
                color: Colors.redAccent,
                fontWeight: FontWeight.w600,
              ),
            ),
      onTap: () => NavigationNotifier.logout(context, ref),
    );
  }
}
