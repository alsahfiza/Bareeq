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
        stream: service.getProducts(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final products = snapshot.data!;

          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const ProductFormDialog(),
                    );
                  },
                  child: const Text('Add Product'),
                ),
              ),
              Expanded(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Stock')),
                    DataColumn(label: Text('Sale')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: products.map((p) {
                    return DataRow(cells: [
                      DataCell(Text(p.name)),
                      DataCell(Text(p.price.toString())),
                      DataCell(Text(p.stock.toString())),
                      DataCell(Icon(
                        p.onSale ? Icons.check : Icons.close,
                        color: p.onSale ? Colors.green : Colors.red,
                      )),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) => ProductFormDialog(product: p),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                service.deleteProduct(p.id),
                          ),
                        ],
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
