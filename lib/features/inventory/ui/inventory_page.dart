import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inventory_table_provider.dart';

class InventoryPage extends ConsumerWidget {
  const InventoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inventoryTableProvider);
    final notifier = ref.read(inventoryTableProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Product ID')),
                  DataColumn(label: Text('Store')),
                  DataColumn(label: Text('Quantity')),
                  DataColumn(label: Text('Adjust')),
                ],
                rows: [
                  for (final i in state.visible)
                    DataRow(
                      cells: [
                        DataCell(Text(i.productId)),
                        DataCell(Text(i.storeId)),
                        DataCell(Text(i.quantity.toString())),
                        DataCell(
                          Row(
                            children: [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: () =>
                                    notifier.adjust(current: i, delta: -1),
                              ),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () =>
                                    notifier.adjust(current: i, delta: 1),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: notifier.prevPage,
                child: const Text('Previous'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: notifier.nextPage,
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
