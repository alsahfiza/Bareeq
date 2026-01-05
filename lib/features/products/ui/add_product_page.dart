import 'package:flutter/material.dart';
import '../widgets/product_form.dart';

class AddProductPage extends StatelessWidget {
  const AddProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add Product',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            ProductForm(
              submitLabel: 'Add Product',
              onSubmit: (product) {
                Navigator.pop(context, product);
              },
            ),
          ],
        ),
      ),
    );
  }
}
