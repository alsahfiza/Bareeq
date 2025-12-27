import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../routing/admin_routes.dart';
import '../../auth/providers/current_user_provider.dart';
import '../../../domain/entities/user_entity.dart';
import 'admin_sidebar.dart';

class AdminShell extends ConsumerStatefulWidget {
  const AdminShell({super.key});

  @override
  ConsumerState<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends ConsumerState<AdminShell> {
  final GlobalKey<NavigatorState> _navKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final bool isDesktop = width >= 1200;
    final bool isRail = width >= 800 && width < 1200;
    final bool isMobile = width < 800;

    final role = UserRole.admin;
    
    final userAsync = ref.watch(currentUserProvider);

    return Scaffold(
      drawer: isMobile
          ? Drawer(
              child: AdminSidebar(
                mode: SidebarMode.expanded,
                role: role,
                onNavigate: _navigate,
              ),
            )
          : null,
      body: Row(
        children: [
          if (!isMobile)
            SizedBox(
              width: isRail ? 72 : 260,
              child: AdminSidebar(
                mode: isRail
                    ? SidebarMode.rail
                    : SidebarMode.expanded,
                role: role,
                onNavigate: _navigate,
              ),
            ),
          Expanded(
            child: Column(
              children: [
                _TopBar(showMenu: isMobile),
                Expanded(
                  child: Navigator(
                    key: _navKey,
                    initialRoute: '/',
                    onGenerateRoute: (settings) {
                      final builder =
                          adminRoutes[settings.name] ??
                              adminRoutes['/']!;
                      return MaterialPageRoute(
                        builder: builder,
                        settings: settings,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigate(String route) {
    _navKey.currentState?.pushReplacementNamed(route);

    if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
      Navigator.of(context).pop();
    }
  }
}

class _TopBar extends StatelessWidget {
  final bool showMenu;

  const _TopBar({required this.showMenu});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade300),
        ),
      ),
      child: Row(
        children: [
          if (showMenu)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          const Text(
            'Bareeq Admin',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          const Icon(Icons.account_circle),
        ],
      ),
    );
  }
}
