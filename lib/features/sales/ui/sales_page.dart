import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/sales_table_provider.dart';
import '../utils/sales_csv_exporter.dart';

class SalesPage extends ConsumerWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(salesTableProvider);
    final notifier = ref.read(salesTableProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sales',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          /// Filters
          Row(
            children: [
              TextButton(
                onPressed: () async {
                  final d = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  notifier.setFrom(d);
                },
                child: const Text('From'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () async {
                  final d = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime.now(),
                  );
                  notifier.setTo(d);
                },
                child: const Text('To'),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  final csv = SalesCsvExporter.export(state.all);
                  final blob = html.Blob([csv]);
                  final url = html.Url.createObjectUrlFromBlob(blob);
                  html.AnchorElement(href: url)
                    ..setAttribute('download', 'sales.csv')
                    ..click();
                  html.Url.revokeObjectUrl(url);
                },
                child: const Text('Export CSV'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Table
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Sale ID')),
                  DataColumn(label: Text('Product')),
                  DataColumn(label: Text('Qty')),
                  DataColumn(label: Text('Total')),
                  DataColumn(label: Text('Profit')),
                  DataColumn(label: Text('Date')),
                ],
                rows: [
                  for (final s in state.visible)
                    DataRow(
                      cells: [
                        DataCell(Text(s.id)),
                        DataCell(Text(s.productId)),
                        DataCell(Text(s.quantity.toString())),
                        DataCell(Text(s.total.toStringAsFixed(2))),
                        DataCell(Text(s.profit.toStringAsFixed(2))),
                        DataCell(
                          Text(
                            s.createdAt
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

          const SizedBox(height: 12),

          /// Totals
          Row(
            children: [
              Text(
                'Total Revenue: ${notifier.totalRevenue.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(width: 24),
              Text(
                'Total Profit: ${notifier.totalProfit.toStringAsFixed(2)}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// Pagination
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
