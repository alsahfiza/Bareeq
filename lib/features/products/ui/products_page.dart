import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/products_provider.dart';

class ProductsPage extends ConsumerWidget {
  const ProductsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productsProvider);

    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.products.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final p = state.products[index];

        return ListTile(
          title: Text(p.name),
          subtitle: Text('SKU: ${p.sku}'),
          trailing: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${p.price.toStringAsFixed(2)} SAR',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                p.isActive ? 'Active' : 'Inactive',
                style: TextStyle(
                  color: p.isActive ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          onTap: () {
            // later: open edit form
          },
        );
      },
    );
  }
}
