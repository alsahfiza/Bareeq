import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/inventory_rules_provider.dart';

class InventoryRulesPage extends ConsumerWidget {
  const InventoryRulesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(inventoryRulesProvider);
    final notifier = ref.read(inventoryRulesProvider.notifier);

    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory Rules (Soft)',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Product ID')),
                DataColumn(label: Text('Minimum Stock')),
                DataColumn(label: Text('Update')),
              ],
              rows: [
                for (final r in state.rules)
                  DataRow(
                    cells: [
                      DataCell(Text(r.productId)),
                      DataCell(Text(r.minimumStock.toString())),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () async {
                            final controller =
                                TextEditingController(
                              text: r.minimumStock.toString(),
                            );

                            final value = await showDialog<int>(
                              context: context,
                              builder: (_) => AlertDialog(
                                title:
                                    const Text('Set Minimum Stock'),
                                content: TextField(
                                  controller: controller,
                                  keyboardType:
                                      TextInputType.number,
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: const Text('Cancel'),
                                  ),
                                  ElevatedButton(
                                    onPressed: () {
                                      Navigator.pop(
                                        context,
                                        int.tryParse(
                                                controller.text) ??
                                            r.minimumStock,
                                      );
                                    },
                                    child: const Text('Save'),
                                  ),
                                ],
                              ),
                            );

                            if (value != null) {
                              notifier.updateRule(
                                r.productId,
                                value,
                              );
                            }
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
