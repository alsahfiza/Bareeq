import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/order_heat_cell.dart';

final orderHeatmapProvider =
    Provider<List<OrderHeatCell>>((ref) {
  return List.generate(
    7 * 6,
    (i) => OrderHeatCell(
      day: i ~/ 6,
      hour: (i % 6) * 4,
      count: (i * 13) % 90,
    ),
  );
});
