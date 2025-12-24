import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../integrity/sales_integrity_provider.dart';

class SalesIntegrityPage extends ConsumerWidget {
  const SalesIntegrityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(salesIntegrityProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text(e.toString()),
        data: (findings) {
          if (findings.isEmpty) {
            return const Text(
              'No sales integrity issues detected.',
              style: TextStyle(fontSize: 16),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sales Integrity Checks',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Sale ID')),
                      DataColumn(label: Text('Product')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Profit')),
                      DataColumn(label: Text('Issue')),
                    ],
                    rows: [
                      for (final f in findings)
                        DataRow(
                          cells: [
                            DataCell(Text(f.saleId)),
                            DataCell(Text(f.productId)),
                            DataCell(Text(f.quantity.toString())),
                            DataCell(
                              Text(
                                f.profit.toStringAsFixed(2),
                                style: TextStyle(
                                  color: f.profit < 0
                                      ? Colors.red
                                      : Colors.black,
                                ),
                              ),
                            ),
                            DataCell(
                              Text(
                                f.issue,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
