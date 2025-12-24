import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../intelligence/sales_intelligence_provider.dart';
import '../intelligence/sales_intelligence_models.dart';
import '../intelligence/sales_intelligence_csv.dart';

class SalesIntelligencePage extends ConsumerStatefulWidget {
  const SalesIntelligencePage({super.key});

  @override
  ConsumerState<SalesIntelligencePage> createState() =>
      _SalesIntelligencePageState();
}

class _SalesIntelligencePageState
    extends ConsumerState<SalesIntelligencePage> {
  DateTime from = DateTime.now().subtract(const Duration(days: 30));
  DateTime to = DateTime.now();
  TimeBucket bucket = TimeBucket.daily;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(
      salesIntelligenceProvider(
        _Params(from: from, to: to, bucket: bucket),
      ),
    );

    return Padding(
      padding: const EdgeInsets.all(24),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text(e.toString()),
        data: (data) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Sales Intelligence',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              /// Controls
              Row(
                children: [
                  DropdownButton<TimeBucket>(
                    value: bucket,
                    items: const [
                      DropdownMenuItem(
                        value: TimeBucket.daily,
                        child: Text('Daily'),
                      ),
                      DropdownMenuItem(
                        value: TimeBucket.weekly,
                        child: Text('Weekly'),
                      ),
                    ],
                    onChanged: (v) => setState(() => bucket = v!),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      final csv =
                          SalesIntelligenceCsv.productRanks(data.productRanks);
                      _download(csv, 'product_sales.csv');
                    },
                    child: const Text('Export Products'),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Product ranking
              Expanded(
                child: SingleChildScrollView(
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Product')),
                      DataColumn(label: Text('Quantity')),
                      DataColumn(label: Text('Revenue')),
                    ],
                    rows: [
                      for (final ProductSalesRank r in data.productRanks)
                        DataRow(
                          cells: [
                            DataCell(Text(r.productId)),
                            DataCell(Text(r.quantity.toString())),
                            DataCell(
                              Text(r.revenue.toStringAsFixed(2)),
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

  void _download(String csv, String name) {
    final blob = html.Blob([csv]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', name)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}