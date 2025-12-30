import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_state.dart';
import '../../../domain/entities/dashboard_kpi.dart';

class DashboardNotifier extends StateNotifier<DashboardState> {
  DashboardNotifier() : super(DashboardState.initial()) {
    _loadStubData();
  }

  void _loadStubData() async {
    state = state.copyWith(loading: true);

    // ⛔ NO backend yet – fake delay
    await Future.delayed(const Duration(milliseconds: 500));

    state = state.copyWith(
      loading: false,
      kpi: const DashboardKpi(
        totalProducts: 128,
        totalUsers: 42,
        totalSales: 312,
        totalRevenue: 154230.75,
      ),
    );
  }
}
