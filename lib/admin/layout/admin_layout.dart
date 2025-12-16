import 'package:flutter/material.dart';

class AdminLayout extends StatelessWidget {
  final String title;
  final Widget body;

  const AdminLayout({
    super.key,
    required this.title,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text(
                'Admin Panel',
                style: TextStyle(fontSize: 20),
              ),
            ),
            _item(context, 'Products', '/products'),
            _item(context, 'Categories', '/categories'),
            _item(context, 'Orders', '/orders'),
            _item(context, 'Settings', '/settings'),
          ],
        ),
      ),
      body: body,
    );
  }

  Widget _item(BuildContext context, String title, String route) {
    return ListTile(
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, route);
      },
    );
  }
}
