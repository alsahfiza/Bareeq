import 'package:flutter/material.dart';
import '../../shared/services/product_service.dart';
import '../../shared/models/product_model.dart';
import '../layout/admin_layout.dart';
import '../widgets/product_form_dialog.dart';

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = ProductService();

    return AdminLayout(
      title: 'Products',
      body: StreamBuilder<List<ProductModel>>(
        stream: service.streamProducts(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
                child: CircularProgressIndicator());
          }

          final products = snapshot.data!;

          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (_) =>
                            const ProductFormDialog(),
                      );
                    },
                    child: const Text('Add Product'),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (_, i) {
                    final p = products[i];
                    return ListTile(
                      title: Text(p.name),
                      subtitle: Text(
                          'SAR ${p.price} | Stock: ${p.stock}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Switch(
                            value: p.isActive,
                            onChanged: (v) {
                              service.update(
                                  p.id, {'isActive': v});
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) =>
                                    ProductFormDialog(
                                        product: p),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              service.delete(p.id);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
