import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/dashboard/get_dashboard_kpis.dart';
import 'repository_providers.dart';

final getDashboardKpisProvider =
    Provider<GetDashboardKpis>((ref) {
  return GetDashboardKpis(
    salesRepository: ref.read(salesRepositoryProvider),
    inventoryRepository: ref.read(inventoryRepositoryProvider),
  );
});
