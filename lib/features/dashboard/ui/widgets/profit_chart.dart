import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/layout/admin_card.dart';
import '../../providers/profit_chart_provider.dart';

class ProfitChart extends ConsumerWidget {
  const ProfitChart({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(profitChartProvider);

    return AdminCard(
      title: 'Profit',
      child: SizedBox(
        height: 260,
        child: Center(
          child: Text(
            'Line chart (${data.length} points)',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
      ),
    );
  }
}
