import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/repositories_impl/product_repository_impl.dart';
import '../../data/repositories_impl/inventory_repository_impl.dart';
import '../../data/repositories_impl/sales_repository_impl.dart';
import '../../data/repositories_impl/user_repository_impl.dart';
import '../../data/repositories_impl/audit_log_repository_impl.dart';
import '../../data/datasources/firestore/data_snapshot_firestore_datasource.dart';
import '../../data/repositories_impl/data_snapshot_repository_impl.dart';
import '../../data/datasources/firestore/audit_firestore_datasource.dart';
import '../../data/repositories_impl/audit_log_repository_impl.dart';
import '../../data/datasources/firestore/user_firestore_datasource.dart';
import '../../domain/repositories/user_repository.dart';
import 'datasource_providers.dart';

final productRepositoryProvider =
    Provider<ProductRepositoryImpl>((ref) {
  return ProductRepositoryImpl(ref.read(productDatasourceProvider));
});

final inventoryRepositoryProvider =
    Provider<InventoryRepositoryImpl>((ref) {
  return InventoryRepositoryImpl(ref.read(inventoryDatasourceProvider));
});

final salesRepositoryProvider =
    Provider<SalesRepositoryImpl>((ref) {
  return SalesRepositoryImpl(ref.read(salesDatasourceProvider));
});

final userRepositoryProvider =
    Provider<UserRepository>((ref) {
  return UserRepositoryImpl(
    UserFirestoreDatasource(FirebaseFirestore.instance),
  );
});

final dataSnapshotRepositoryProvider =
    Provider<DataSnapshotRepositoryImpl>((ref) {
  return DataSnapshotRepositoryImpl(
    DataSnapshotFirestoreDatasource(FirebaseFirestore.instance),
  );
});

final auditLogRepositoryProvider =
    Provider<AuditLogRepositoryImpl>((ref) {
  return AuditLogRepositoryImpl(
    AuditFirestoreDatasource(FirebaseFirestore.instance),
  );
});