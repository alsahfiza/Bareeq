import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/sales_purchase_point.dart';
import '../domain/chart_time_range.dart';
import 'chart_time_range_provider.dart';

final salesPurchaseChartProvider =
    Provider<List<SalesPurchasePoint>>((ref) {
  final range = ref.watch(chartTimeRangeProvider);

  switch (range) {
    case ChartTimeRange.day:
      return const [
        SalesPurchasePoint(label: '2am', sales: 60000, purchase: 35000),
        SalesPurchasePoint(label: '6am', sales: 50000, purchase: 42000),
        SalesPurchasePoint(label: '10am', sales: 68000, purchase: 48000),
        SalesPurchasePoint(label: '2pm', sales: 72000, purchase: 52000),
        SalesPurchasePoint(label: '6pm', sales: 80000, purchase: 58000),
        SalesPurchasePoint(label: '10pm', sales: 86000, purchase: 62000),
      ];

    case ChartTimeRange.week:
      return const [
        SalesPurchasePoint(label: 'Mon', sales: 420000, purchase: 310000),
        SalesPurchasePoint(label: 'Tue', sales: 460000, purchase: 330000),
        SalesPurchasePoint(label: 'Wed', sales: 480000, purchase: 350000),
        SalesPurchasePoint(label: 'Thu', sales: 500000, purchase: 360000),
        SalesPurchasePoint(label: 'Fri', sales: 550000, purchase: 390000),
        SalesPurchasePoint(label: 'Sat', sales: 600000, purchase: 420000),
        SalesPurchasePoint(label: 'Sun', sales: 580000, purchase: 400000),
      ];

    case ChartTimeRange.month:
      return const [
        SalesPurchasePoint(label: 'Jan', sales: 2200000, purchase: 1600000),
        SalesPurchasePoint(label: 'Feb', sales: 2100000, purchase: 1500000),
        SalesPurchasePoint(label: 'Mar', sales: 2400000, purchase: 1700000),
        SalesPurchasePoint(label: 'Apr', sales: 2600000, purchase: 1800000),
        SalesPurchasePoint(label: 'May', sales: 2800000, purchase: 1950000),
        SalesPurchasePoint(label: 'Jun', sales: 3000000, purchase: 2100000),
      ];
  }
});
