import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../state/sidebar_collapsed_provider.dart';
import '../state/active_route_provider.dart';
import '../routing/app_routes.dart';

class AdminTopBar extends ConsumerWidget {
  const AdminTopBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collapsed = ref.watch(sidebarCollapsedProvider);
    final route = ref.watch(activeRouteProvider);

    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.account_circle, size: 28),
          const Spacer(),
        ],
      ),
    );
  }
}
