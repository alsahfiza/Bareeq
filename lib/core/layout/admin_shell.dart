import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/providers/auth_state_provider.dart';
import '../state/active_route_provider.dart';
import '../routing/app_routes.dart';
import '../state/sidebar_collapsed_provider.dart';
import 'admin_sidebar.dart';

class AdminShell extends ConsumerWidget {
  final Widget child;

  const AdminShell({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          // 🖱️ MouseRegion BELONGS HERE
          MouseRegion(
            cursor: SystemMouseCursors.basic,
            onEnter: (_) {
              // Reserved for hover-expand behavior (optional)
              // Example:
              // ref.read(sidebarCollapsedProvider.notifier).state = false;
            },
            onExit: (_) {
              // Reserved for hover-collapse behavior (optional)
              // Example:
              // ref.read(sidebarCollapsedProvider.notifier).state = true;
            },
            child: const AdminSidebar(),
          ),

          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 120),
              switchInCurve: Curves.easeOut,
              switchOutCurve: Curves.easeIn,
              child: KeyedSubtree(
                key: ValueKey(currentRoute),
                child: child,
              ),
            ),
          ),
        ],
      ),
    );
  }
}