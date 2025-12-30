import '../../../domain/entities/dashboard_kpi.dart';

class DashboardState {
  final bool loading;
  final DashboardKpi kpi;
  final String? error;

  const DashboardState({
    required this.loading,
    required this.kpi,
    this.error,
  });

  factory DashboardState.initial() {
    return DashboardState(
      loading: false,
      kpi: DashboardKpi.empty(),
      error: null,
    );
  }

  DashboardState copyWith({
    bool? loading,
    DashboardKpi? kpi,
    String? error,
  }) {
    return DashboardState(
      loading: loading ?? this.loading,
      kpi: kpi ?? this.kpi,
      error: error,
    );
  }
}
