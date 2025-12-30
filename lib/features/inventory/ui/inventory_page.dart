import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inventory_provider.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inventoryProvider);

    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: state.items.length,
      separatorBuilder: (_, __) => const Divider(),
      itemBuilder: (context, index) {
        final i = state.items[index];
        final lowStock = i.quantity <= i.minStock;

        return ListTile(
          title: Text(i.productName),
          subtitle: Text('Stock: ${i.quantity} | Min: ${i.minStock}'),
          trailing: Text(
            lowStock ? 'LOW' : 'OK',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: lowStock ? Colors.red : Colors.green,
            ),
          ),
          onTap: () {
            // later: adjust stock / view history
          },
        );
      },
    );
  }
}
