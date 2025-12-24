import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories_impl/product_repository_impl.dart';
import '../../data/repositories_impl/inventory_repository_impl.dart';
import '../../data/repositories_impl/sales_repository_impl.dart';
import '../../data/repositories_impl/user_repository_impl.dart';
import '../../data/repositories_impl/audit_log_repository_impl.dart';
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
    Provider<UserRepositoryImpl>((ref) {
  return UserRepositoryImpl(ref.read(userDatasourceProvider));
});

final auditRepositoryProvider =
    Provider<AuditLogRepositoryImpl>((ref) {
  return AuditLogRepositoryImpl(ref.read(auditDatasourceProvider));
});
