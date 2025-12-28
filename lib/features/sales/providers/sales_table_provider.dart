import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/sale_entity.dart';

final salesTableProvider =
    StateNotifierProvider<SalesTableNotifier, SalesTableState>(
  (ref) => SalesTableNotifier(),
);

class SalesTableNotifier extends StateNotifier<SalesTableState> {
  SalesTableNotifier() : super(SalesTableState.empty());

  void setFrom(DateTime _) {}
  void setTo(DateTime _) {}

  void prevPage() {}
  void nextPage() {}

  double get totalRevenue => 0;
  double get totalProfit => 0;
}

class SalesTableState {
  final List<SaleEntity> all;
  final List<SaleEntity> visible;

  const SalesTableState({
    required this.all,
    required this.visible,
  });

  factory SalesTableState.empty() =>
      const SalesTableState(all: [], visible: []);
}
