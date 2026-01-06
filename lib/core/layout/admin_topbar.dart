import 'package:flutter/material.dart';

class AdminTopBar extends StatelessWidget {
  final VoidCallback onToggleSidebar;

  const AdminTopBar({
    super.key,
    required this.onToggleSidebar,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade800),
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: onToggleSidebar,
          ),
          const SizedBox(width: 12),
          const Text(
            'Admin',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          const Icon(Icons.account_circle,
              color: Colors.white, size: 28),
        ],
      ),
    );
  }
}
