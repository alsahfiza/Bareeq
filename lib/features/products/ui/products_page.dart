import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_table_provider.dart';
import '../providers/product_form_provider.dart';
import 'product_form_page.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productsTableProvider);
    final tableNotifier = ref.read(productsTableProvider.notifier);
    final formNotifier = ref.read(productFormProvider.notifier);
    final productsAsync = ref.watch(productsTableProvider);

    return productsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (products) => ListView(
        children: [
          for (final p in products)
            ListTile(
              title: Text(p.name),
              subtitle: Text(p.sku),
              trailing: IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () {
                  ref.read(productFormProvider.notifier).loadForEdit(p);
                },
              ),
            ),
        ],
      ),
    );

    //     crossAxisAlignment: CrossAxisAlignment.start,
    //     children: [
    //       const Text(
    //         'Products',
    //         style: TextStyle(
    //           fontSize: 20,
    //           fontWeight: FontWeight.bold,
    //         ),
    //       ),
    //       const SizedBox(height: 16),

    //       /// Search
    //       TextField(
    //         decoration: const InputDecoration(
    //           hintText: 'Search by name or SKU',
    //           border: OutlineInputBorder(),
    //         ),
    //         onChanged: tableNotifier.search,
    //       ),

    //       const SizedBox(height: 16),

    //       /// Table
    //       Expanded(
    //         child: SingleChildScrollView(
    //           child: DataTable(
    //             columns: const [
    //               DataColumn(label: Text('Name')),
    //               DataColumn(label: Text('SKU')),
    //               DataColumn(label: Text('Category')),
    //               DataColumn(label: Text('Price')),
    //               DataColumn(label: Text('Cost')),
    //               DataColumn(label: Text('Status')),
    //             ],
    //             rows: [
    //               for (final p in state.visible)
    //                 DataRow(
    //                   onSelectChanged: (_) {
    //                     formNotifier.loadForEdit(p);
    //                     Navigator.of(context).push(
    //                       MaterialPageRoute(
    //                         builder: (_) => const ProductFormPage(),
    //                       ),
    //                     );
    //                   },
    //                   cells: [
    //                     DataCell(Text(p.name)),
    //                     DataCell(Text(p.sku)),
    //                     DataCell(Text(p.category)),
    //                     DataCell(Text(p.price.toStringAsFixed(2))),
    //                     DataCell(Text(p.cost.toStringAsFixed(2))),
    //                     DataCell(
    //                       Text(
    //                         p.isActive ? 'Active' : 'Inactive',
    //                       ),
    //                     ),
    //                   ],
    //                 ),
    //             ],
    //           ),
    //         ),
    //       ),

    //       const SizedBox(height: 16),

    //       /// Pagination
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.end,
    //         children: [
    //           TextButton(
    //             onPressed: tableNotifier.prevPage,
    //             child: const Text('Previous'),
    //           ),
    //           const SizedBox(width: 8),
    //           TextButton(
    //             onPressed: tableNotifier.nextPage,
    //             child: const Text('Next'),
    //           ),
    //           const SizedBox(width: 16),
    //           ElevatedButton(
    //             onPressed: () {
    //               formNotifier.state = ProductFormState.empty();
    //               Navigator.of(context).push(
    //                 MaterialPageRoute(
    //                   builder: (_) => const ProductFormPage(),
    //                 ),
    //               );
    //             },
    //             child: const Text('Add Product'),
    //           ),
    //         ],
    //       ),
    //     ],
    //   ),
    // );
  }
}
