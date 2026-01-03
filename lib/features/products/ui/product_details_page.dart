import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import 'barcode_scanner_page.dart';
import 'edit_product_page.dart';
import 'add_product_page.dart';

class ProductDetailsPage extends StatelessWidget {
  final Product product;
  const ProductDetailsPage({required this.product, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text("SKU: ${product.sku}"),
          Text("Barcode: ${product.barcode}"),
          Text("Category: ${product.category}"),
          Text("Brand: ${product.brand}"),
          Text("Unit: ${product.unit}"),
          Text("Status: ${product.status}"),
          const SizedBox(height: 16),
          Text("Cost: \$${product.cost}"),
          Text("Price: \$${product.price}"),
          Text("Quantity: ${product.quantity}"),
          Text("Low Stock Alert: ${product.lowStock}"),
        ],
      ),
    );
  }
}
