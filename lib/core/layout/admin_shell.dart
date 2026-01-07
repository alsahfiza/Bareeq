import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/sidebar_collapsed_provider.dart';
import '../routing/app_routes.dart';
import '../state/active_route_provider.dart';
import '../../features/auth/providers/auth_state_provider.dart';

import 'admin_sidebar.dart';
import 'admin_topbar.dart';

class AdminShell extends ConsumerWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  static const double expandedWidth = 260;
  static const double collapsedWidth = 60;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsed = ref.watch(sidebarCollapsedProvider);
    final authState = ref.watch(authStateProvider);
    final currentRoute = ref.read(activeRouteProvider);

    if (!authState.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        final redirect = await Navigator.of(context).pushNamed(
          AppRoutes.login,
          arguments: currentRoute,
        );

        if (redirect != null && context.mounted) {
          Navigator.of(context).pushReplacementNamed(
            redirect as String,
          );
        }
      });

      return const Scaffold(
        body: SizedBox.shrink(),
      );
    }

    return Scaffold(
      body: Row(
        children: [
          // MAIN CONTENT (LEFT)
          Expanded(
            child: Column(
              children: [
                const AdminTopBar(),
                Expanded(child: child),
              ],
            ),
          ),

          // DIVIDER
          Container(width: 1, color: Colors.grey.shade300),

          // RIGHT SIDEBAR (HOVER + CLICK)
          MouseRegion(
            onEnter: (_) =>
                ref.read(sidebarCollapsedProvider.notifier).state = false,
            onExit: (_) =>
                ref.read(sidebarCollapsedProvider.notifier).state = true,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              width: collapsed ? collapsedWidth : expandedWidth,
              child: const AdminSidebar(),
            ),
          ),
        ],
      ),
    );
  }
}
