import 'package:flutter/material.dart';
import 'admin_sidebar.dart';

class AdminShell extends StatefulWidget {
  final Widget child;

  const AdminShell({
    super.key,
    required this.child,
  });

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  bool sidebarOpen = false;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    final isDesktop = width >= 1200;
    final isTablet = width >= 800 && width < 1200;
    final isMobile = width < 800;

    if (isDesktop) {
      return _desktop();
    }

    if (isTablet) {
      return _tablet();
    }

    return _mobile();
  }

  Widget _desktop() {
    return Scaffold(
      body: Row(
        children: [
          const SizedBox(
            width: 260,
            child: AdminSidebar(),
          ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _tablet() {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => setState(() => sidebarOpen = !sidebarOpen),
        ),
      ),
      body: Row(
        children: [
          if (sidebarOpen)
            SizedBox(
              width: 240,
              child: AdminSidebar(
                onNavigate: () => setState(() => sidebarOpen = false),
              ),
            ),
          Expanded(child: widget.child),
        ],
      ),
    );
  }

  Widget _mobile() {
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
      ),
      drawer: Drawer(
        child: AdminSidebar(
          onNavigate: () => Navigator.of(context).pop(),
        ),
      ),
      body: widget.child,
    );
  }
}
