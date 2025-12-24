import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_kpi_provider.dart';
import 'kpi_card.dart';

class KpiGrid extends ConsumerWidget {
  const KpiGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(dashboardKpiProvider);
    final notifier = ref.read(dashboardKpiProvider.notifier);

    if (state.loading || state.data == null) {
      return const SizedBox.shrink();
    }

    final d = state.data!;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () async {
                final from = await showDatePicker(
                  context: context,
                  firstDate: DateTime(2020),
                  lastDate: DateTime.now(),
                );
                if (from == null) return;

                final to = await showDatePicker(
                  context: context,
                  firstDate: from,
                  lastDate: DateTime.now(),
                );
                if (to == null) return;

                notifier.updateRange(from, to);
              },
              child: const Text('Change Date Range'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: 4,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            KpiCard(
              title: 'Total Sales',
              value: d.totalSales.toStringAsFixed(0),
              trend: d.salesTrend,
            ),
            KpiCard(
              title: 'Revenue',
              value: d.totalRevenue.toStringAsFixed(2),
              trend: d.revenueTrend,
            ),
            KpiCard(
              title: 'Profit',
              value: d.totalProfit.toStringAsFixed(2),
              trend: d.profitTrend,
            ),
            KpiCard(
              title: 'Low Stock Items',
              value: d.lowStockCount.toString(),
              trend: 0,
            ),
          ],
        ),
      ],
    );
  }
}
