import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/sidebar_collapsed_provider.dart';
import 'admin_sidebar.dart';
import 'admin_topbar.dart';

class AdminShell extends ConsumerWidget {
  final Widget child;
  const AdminShell({super.key, required this.child});

  static const double expandedWidth = 260;
  static const double collapsedWidth = 72;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsed = ref.watch(sidebarCollapsedProvider);

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
