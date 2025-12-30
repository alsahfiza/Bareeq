import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/profit_point.dart';
import '../domain/chart_time_range.dart';
import 'chart_time_range_provider.dart';

final profitChartProvider = Provider<List<ProfitPoint>>((ref) {
  final range = ref.watch(chartTimeRangeProvider);

  switch (range) {
    case ChartTimeRange.day:
      return const [
        ProfitPoint(label: '2am', profit: 18000),
        ProfitPoint(label: '6am', profit: 22000),
        ProfitPoint(label: '10am', profit: 26000),
        ProfitPoint(label: '2pm', profit: 30000),
        ProfitPoint(label: '6pm', profit: 35000),
      ];

    case ChartTimeRange.week:
      return const [
        ProfitPoint(label: 'Mon', profit: 120000),
        ProfitPoint(label: 'Tue', profit: 140000),
        ProfitPoint(label: 'Wed', profit: 160000),
        ProfitPoint(label: 'Thu', profit: 170000),
        ProfitPoint(label: 'Fri', profit: 190000),
      ];

    case ChartTimeRange.month:
      return const [
        ProfitPoint(label: 'Jan', profit: 680000),
        ProfitPoint(label: 'Feb', profit: 720000),
        ProfitPoint(label: 'Mar', profit: 790000),
        ProfitPoint(label: 'Apr', profit: 850000),
        ProfitPoint(label: 'May', profit: 910000),
      ];
  }
});
