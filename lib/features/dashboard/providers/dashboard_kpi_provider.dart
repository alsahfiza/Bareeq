import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../data/datasources/dashboard_firestore_datasource.dart';
import '../../../domain/entities/dashboard_kpi.dart';

final dashboardDatasourceProvider =
    Provider<DashboardFirestoreDatasource>(
  (ref) => DashboardFirestoreDatasource(FirebaseFirestore.instance),
);

final dashboardKpiProvider = FutureProvider<DashboardKpi>((ref) {
  return ref.read(dashboardDatasourceProvider).loadKpis();
});