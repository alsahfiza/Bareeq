import 'package:flutter/material.dart';
import '../../shared/models/product_model.dart';
import '../../shared/services/product_service.dart';
import '../layout/admin_layout.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final productService = ProductService();

    return AdminLayout(
      title: 'Dashboard',
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Low Stock Alerts',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: StreamBuilder<List<ProductModel>>(
                stream: productService.getLowStockProducts(5),
                builder: (_, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                        child: CircularProgressIndicator());
                  }

                  final products = snapshot.data!;

                  if (products.isEmpty) {
                    return const Center(
                      child: Text(
                        'All products have sufficient stock',
                        style: TextStyle(color: Colors.green),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (_, index) {
                      final product = products[index];

                      return Card(
                        color: Colors.red.shade50,
                        margin:
                            const EdgeInsets.symmetric(vertical: 6),
                        child: ListTile(
                          leading: const Icon(
                            Icons.warning,
                            color: Colors.red,
                          ),
                          title: Text(product.name),
                          subtitle: Text(
                            'Stock remaining: ${product.stock}',
                            style:
                                const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
