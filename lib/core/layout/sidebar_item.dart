import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final String title;
  final String route;
  final IconData icon;
  final VoidCallback? onNavigate;

  const SidebarItem({
    super.key,
    required this.title,
    required this.route,
    required this.icon,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final current = ModalRoute.of(context)?.settings.name;
    final selected = current == route;

    return ListTile(
      leading: Icon(icon, color: selected ? Colors.blue : Colors.black54),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          color: selected ? Colors.blue : Colors.black,
        ),
      ),
      selected: selected,
      onTap: () {
        if (!selected) {
          Navigator.of(context).pushReplacementNamed(route);
        }
        onNavigate?.call();
      },
    );
  }
}
