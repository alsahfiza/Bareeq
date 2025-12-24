import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/sale_entity.dart';
import '../../../core/config/usecase_providers.dart';

class SalesTableState {
  final List<SaleEntity> all;
  final List<SaleEntity> visible;
  final int page;
  final int pageSize;
  final DateTime? from;
  final DateTime? to;

  const SalesTableState({
    required this.all,
    required this.visible,
    required this.page,
    required this.pageSize,
    this.from,
    this.to,
  });

  SalesTableState copyWith({
    List<SaleEntity>? all,
    List<SaleEntity>? visible,
    int? page,
    int? pageSize,
    DateTime? from,
    DateTime? to,
  }) {
    return SalesTableState(
      all: all ?? this.all,
      visible: visible ?? this.visible,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }
}

final salesTableProvider =
    StateNotifierProvider<SalesTableNotifier, SalesTableState>((ref) {
  return SalesTableNotifier(ref);
});

class SalesTableNotifier extends StateNotifier<SalesTableState> {
  final Ref ref;

  SalesTableNotifier(this.ref)
      : super(const SalesTableState(
          all: [],
          visible: [],
          page: 0,
          pageSize: 12,
        )) {
    _load();
  }

  Future<void> _load() async {
    final data = await ref.read(getSalesProvider).call(
          from: state.from,
          to: state.to,
        );
    state = state.copyWith(all: data);
    _apply();
  }

  void setFrom(DateTime? v) {
    state = state.copyWith(from: v, page: 0);
    _load();
  }

  void setTo(DateTime? v) {
    state = state.copyWith(to: v, page: 0);
    _load();
  }

  void nextPage() {
    state = state.copyWith(page: state.page + 1);
    _apply();
  }

  void prevPage() {
    if (state.page == 0) return;
    state = state.copyWith(page: state.page - 1);
    _apply();
  }

  void _apply() {
    final start = state.page * state.pageSize;
    final end = (start + state.pageSize).clamp(0, state.all.length);
    state = state.copyWith(
      visible: state.all.sublist(start, end),
    );
  }

  double get totalRevenue {
    double sum = 0;
    for (final s in state.all) {
      sum += s.total;
    }
    return sum;
  }

  double get totalProfit {
    double sum = 0;
    for (final s in state.all) {
      sum += s.profit;
    }
    return sum;
  }
}
