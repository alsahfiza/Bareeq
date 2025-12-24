import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/firestore/product_firestore_datasource.dart';
import '../../data/datasources/firestore/inventory_firestore_datasource.dart';
import '../../data/datasources/firestore/sales_firestore_datasource.dart';
import '../../data/datasources/firestore/user_firestore_datasource.dart';
import '../../data/datasources/firestore/audit_firestore_datasource.dart';
import '../../domain/usecases/dashboard/get_dashboard_kpis.dart';
import 'repository_providers.dart';
import 'firebase_provider.dart';

final productDatasourceProvider =
    Provider<ProductFirestoreDatasource>((ref) {
  return ProductFirestoreDatasource(ref.read(firestoreProvider));
});

final inventoryDatasourceProvider =
    Provider<InventoryFirestoreDatasource>((ref) {
  return InventoryFirestoreDatasource(ref.read(firestoreProvider));
});

final salesDatasourceProvider =
    Provider<SalesFirestoreDatasource>((ref) {
  return SalesFirestoreDatasource(ref.read(firestoreProvider));
});

final userDatasourceProvider =
    Provider<UserFirestoreDatasource>((ref) {
  return UserFirestoreDatasource(ref.read(firestoreProvider));
});

final auditDatasourceProvider =
    Provider<AuditFirestoreDatasource>((ref) {
  return AuditFirestoreDatasource(ref.read(firestoreProvider));
});

final getDashboardKpisProvider = Provider<GetDashboardKpis>((ref) {
  return GetDashboardKpis(
    salesRepository: ref.read(salesRepositoryProvider),
    inventoryRepository: ref.read(inventoryRepositoryProvider),
  );
});