import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final String title;
  final String route;
  final IconData icon;

  const SidebarItem({
    required this.title,
    required this.route,
    required this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white70),
      ),
      onTap: () {
        Navigator.of(context).pushReplacementNamed(route);
      },
    );
  }
}
