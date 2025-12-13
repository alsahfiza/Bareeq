import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () => context.go('/'),
            child: const Text(
              'بريق BAREEQ',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              _navItem(context, 'الرئيسية', '/'),
              _navItem(context, 'من نحن', '/about'),
              _navItem(context, 'تواصل معنا', '/contact'),
            ],
          )
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, String title, String route) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: InkWell(
        onTap: () => context.go(route),
        child: Text(title, style: const TextStyle(fontSize: 18)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(70);
}
