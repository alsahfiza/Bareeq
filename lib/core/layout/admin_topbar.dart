import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/active_route_provider.dart';
import '../state/sidebar_collapsed_provider.dart';
import '../routing/app_routes.dart';
import '../state/navigation_notifier.dart';

class AdminTopBar extends ConsumerWidget {
  const AdminTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(activeRouteProvider);
    final collapsed = ref.watch(sidebarCollapsedProvider);

    return Container(
      height: 56,
      color: Colors.grey.shade800,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade800),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(
              collapsed ? Icons.menu : Icons.menu_open,
            ),
            onPressed: () {
              // ref.read(sidebarCollapsedProvider.notifier).toggle();
              ref.read(sidebarCollapsedProvider.notifier).state = !collapsed;
            },
          ),

          const SizedBox(width: 12),

          Text(
            _title(route),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),

          const Spacer(),

          const Icon(Icons.account_circle, size: 28),

          const SizedBox(width: 12),

          TextButton(
            onPressed: () =>
                NavigationNotifier.logout(context, ref),
            child: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  String _title(String route) {
    switch (route) {
      case AppRoutes.dashboard:
        return 'Dashboard';
      case AppRoutes.products:
        return 'Products';
      case AppRoutes.inventory:
        return 'Inventory';
      case AppRoutes.sales:
        return 'Sales';
      case AppRoutes.users:
        return 'Users';
      case AppRoutes.snapshots:
        return 'Snapshots';
      case AppRoutes.systemHealth:
        return 'System Health';
      default:
        return '';
    }
  }
}
