import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../intelligence/product_inventory_intelligence_provider.dart';
import '../intelligence/product_inventory_intelligence.dart';

class ProductInventoryIntelligencePage extends ConsumerWidget {
  const ProductInventoryIntelligencePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(productInventoryIntelligenceProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text(e.toString()),
        data: (items) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Product Inventory Intelligence',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Product')),
                      DataColumn(label: Text('Total Stock')),
                      DataColumn(label: Text('Severity')),
                      DataColumn(label: Text('Stores')),
                    ],
                    rows: [
                      for (final item in items)
                        DataRow(
                          cells: [
                            DataCell(Text(item.productName)),
                            DataCell(Text(item.totalStock.toString())),
                            DataCell(
                              Text(
                                _severityLabel(item.severity),
                                style: TextStyle(
                                  color: _severityColor(item.severity),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  for (final e
                                      in item.stockByStore.entries)
                                    Text(
                                      '${e.key}: ${e.value}',
                                      style: const TextStyle(fontSize: 12),
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
            ],
          );
        },
      ),
    );
  }

  static String _severityLabel(StockSeverity s) {
    switch (s) {
      case StockSeverity.ok:
        return 'OK';
      case StockSeverity.warning:
        return 'Warning';
      case StockSeverity.critical:
        return 'Critical';
    }
  }

  static Color _severityColor(StockSeverity s) {
    switch (s) {
      case StockSeverity.ok:
        return Colors.green;
      case StockSeverity.warning:
        return Colors.orange;
      case StockSeverity.critical:
        return Colors.red;
    }
  }
}
