import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/dashboard_kpi_entity.dart';
import '../../../core/config/dashboard_providers.dart';

class DashboardKpiState {
  final DashboardKpiEntity? data;
  final DateTime from;
  final DateTime to;
  final bool loading;

  const DashboardKpiState({
    required this.data,
    required this.from,
    required this.to,
    required this.loading,
  });

  DashboardKpiState copyWith({
    DashboardKpiEntity? data,
    DateTime? from,
    DateTime? to,
    bool? loading,
  }) {
    return DashboardKpiState(
      data: data ?? this.data,
      from: from ?? this.from,
      to: to ?? this.to,
      loading: loading ?? this.loading,
    );
  }
}

final dashboardKpiProvider =
    StateNotifierProvider<DashboardKpiNotifier, DashboardKpiState>((ref) {
  return DashboardKpiNotifier(ref);
});

class DashboardKpiNotifier extends StateNotifier<DashboardKpiState> {
  final Ref ref;

  DashboardKpiNotifier(this.ref)
      : super(DashboardKpiState(
          data: null,
          from: DateTime.now().subtract(const Duration(days: 7)),
          to: DateTime.now(),
          loading: true,
        )) {
    _load();
  }

  Future<void> _load() async {
    state = state.copyWith(loading: true);
    final data = await ref.read(getDashboardKpisProvider).call(
          from: state.from,
          to: state.to,
        );
    state = state.copyWith(data: data, loading: false);
  }

  void updateRange(DateTime from, DateTime to) {
    state = state.copyWith(from: from, to: to);
    _load();
  }
}
