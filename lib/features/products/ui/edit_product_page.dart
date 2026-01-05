import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import '../widgets/product_form.dart';

class EditProductPage extends StatelessWidget {
  final ProductModel product;

  const EditProductPage({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Edit Product',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),

            ProductForm(
              initial: product,
              submitLabel: 'Save Changes',
              onSubmit: (updated) {
                Navigator.pop(context, updated);
              },
            ),
          ],
        ),
      ),
    );
  }
}
