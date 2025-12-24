import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/providers/current_user_provider.dart';
import '../navigation/sidebar_items.dart';
import 'sidebar_header.dart';
import 'sidebar_item.dart';

class AdminSidebar extends ConsumerWidget {
  const AdminSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(currentUserProvider);

    if (userState is! CurrentUserReady) {
      return const SizedBox.shrink();
    }

    final role = userState.user.role;

    return Container(
      width: 260,
      color: const Color(0xFF1E1E2D),
      child: Column(
        children: [
          SidebarHeader(),
          for (final item in sidebarItems)
            if (item.isAllowed(role))
              SidebarItem(
                title: item.title,
                route: item.route,
                icon: item.icon,
              ),
        ],
      ),
    );
  }
}
