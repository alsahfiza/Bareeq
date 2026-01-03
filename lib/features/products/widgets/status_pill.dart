import 'package:flutter/material.dart';

class StatusPill extends StatelessWidget {
  final String status;
  const StatusPill({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    Color bg;
    Color fg;

    switch (status) {
      case "Active":
        bg = Colors.green.shade50;
        fg = Colors.green;
        break;
      case "Low":
        bg = Colors.orange.shade50;
        fg = Colors.orange;
        break;
      default:
        bg = Colors.red.shade50;
        fg = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status,
        style:
            TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
