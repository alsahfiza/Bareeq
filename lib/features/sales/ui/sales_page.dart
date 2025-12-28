import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/sales_table_provider.dart';

class SalesPage extends ConsumerWidget {
  const SalesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(salesTableProvider);

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Sales',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView(
              children: [
                for (final s in state.all)
                  ListTile(
                    title: Text(s.total.toStringAsFixed(2)),
                    subtitle: Text(s.createdAt.toIso8601String()),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text('Total Revenue: ${state.totalRevenue.toStringAsFixed(2)}'),
          Text('Total Profit: ${state.totalProfit.toStringAsFixed(2)}'),
        ],
      ),
    );
  }
}
