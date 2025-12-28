import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/sale_entity.dart';
import '../../../core/config/sales_providers.dart';

class SalesTableState {
  final List<SaleEntity> all;
  final DateTime? from;
  final DateTime? to;

  SalesTableState({
    required this.all,
    this.from,
    this.to,
  });

  double get totalRevenue =>
      all.fold(0, (s, e) => s + e.total);

  double get totalProfit =>
      all.fold(0, (s, e) => s + e.profit);
}

class SalesTableNotifier extends StateNotifier<SalesTableState> {
  final Ref ref;

  SalesTableNotifier(this.ref)
      : super(SalesTableState(all: [])) {
    load();
  }

  Future<void> load() async {
    final data = await ref.read(getSalesProvider).call(
          from: state.from,
          to: state.to,
        );
    state = SalesTableState(all: data, from: state.from, to: state.to);
  }

  void setFrom(DateTime? d) {
    state = SalesTableState(all: state.all, from: d, to: state.to);
    load();
  }

  void setTo(DateTime? d) {
    state = SalesTableState(all: state.all, from: state.from, to: d);
    load();
  }
}

final salesTableProvider =
    StateNotifierProvider<SalesTableNotifier, SalesTableState>(
  (ref) => SalesTableNotifier(ref),
);
