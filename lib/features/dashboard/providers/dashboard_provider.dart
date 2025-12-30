import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dashboard_notifier.dart';
import 'dashboard_state.dart';

final dashboardProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>(
  (ref) => DashboardNotifier(),
);
