import 'package:flutter/material.dart';

class ProductActionIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const ProductActionIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: color),
        ),
      ),
    );
  }
}
