import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.go('/products/${category.id}'),
      child: Container(
        width: 250,
        height: 180,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.teal, width: 2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network(category.imageUrl, height: 80),
            const SizedBox(height: 10),
            Text(category.nameAr, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}