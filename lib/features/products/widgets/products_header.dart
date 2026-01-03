import 'package:flutter/material.dart';

class ProductsHeader extends StatelessWidget {
  final VoidCallback onAdd;

  const ProductsHeader({super.key, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          "Products",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        ElevatedButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text("Add Product"),
        ),
      ],
    );
  }
}
