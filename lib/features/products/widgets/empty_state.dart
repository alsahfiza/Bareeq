import 'package:flutter/material.dart';

class EmptyState extends StatelessWidget {
  const EmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: const [
          Icon(Icons.inventory_2_outlined,
              size: 64, color: Colors.grey),
          SizedBox(height: 12),
          Text("No products found",
              style: TextStyle(fontWeight: FontWeight.w600)),
          SizedBox(height: 6),
          Text(
            "Try adjusting your filters or add a new product",
            style: TextStyle(color: Colors.black54),
          ),
        ],
      ),
    );
  }
}
