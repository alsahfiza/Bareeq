import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/chart_time_range.dart';

final chartTimeRangeProvider =
    StateProvider<ChartTimeRange>((ref) {
  return ChartTimeRange.day;
});
