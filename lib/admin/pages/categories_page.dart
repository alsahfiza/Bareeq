import 'package:flutter/material.dart';
import '../../shared/models/category_model.dart';
import '../../shared/services/category_service.dart';
import '../layout/admin_layout.dart';
import '../widgets/category_form_dialog.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = CategoryService();

    return AdminLayout(
      title: 'Categories',
      body: StreamBuilder<List<CategoryModel>>(
        stream: service.getCategories(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final categories = snapshot.data!;

          return Column(
            children: [
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  child: const Text('Add Category'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (_) => const CategoryFormDialog(),
                    );
                  },
                ),
              ),
              Expanded(
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Name')),
                    DataColumn(label: Text('Order')),
                    DataColumn(label: Text('Active')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: categories.map((c) {
                    return DataRow(cells: [
                      DataCell(Text(c.name)),
                      DataCell(Text(c.order.toString())),
                      DataCell(
                        Icon(
                          c.isActive ? Icons.check : Icons.close,
                          color: c.isActive ? Colors.green : Colors.red,
                        ),
                      ),
                      DataCell(Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (_) =>
                                    CategoryFormDialog(category: c),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () =>
                                service.deleteCategory(c.id),
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
