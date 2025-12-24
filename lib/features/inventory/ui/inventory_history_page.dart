import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inventory_history_provider.dart';

class InventoryHistoryPage extends ConsumerWidget {
  const InventoryHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inventoryHistoryProvider);
    final notifier = ref.read(inventoryHistoryProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory Adjustment History',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Entity ID')),
                  DataColumn(label: Text('Before')),
                  DataColumn(label: Text('After')),
                  DataColumn(label: Text('By')),
                  DataColumn(label: Text('Date')),
                ],
                rows: [
                  for (final log in state.visible)
                    DataRow(
                      cells: [
                        DataCell(Text(log.entityId)),
                        DataCell(Text(log.before['quantity'].toString())),
                        DataCell(Text(log.after['quantity'].toString())),
                        DataCell(Text(log.performedBy)),
                        DataCell(
                          Text(
                            log.timestamp
                                .toIso8601String()
                                .split('T')
                                .first,
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
