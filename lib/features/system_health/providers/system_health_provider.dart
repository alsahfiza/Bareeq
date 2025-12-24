import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/usecase_providers.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/entities/inventory_entity.dart';
import '../../../domain/entities/sale_entity.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/audit_log_entity.dart';
import '../models/system_health_snapshot.dart';

final systemHealthProvider =
    FutureProvider<SystemHealthSnapshot>((ref) async {
  final products = await ref.read(getProductsProvider).call();
  final inventory = await ref.read(getInventoryProvider).call();
  final sales = await ref.read(getSalesProvider).call();
  final users = await ref.read(getUsersProvider).call();
  final audits = await ref.read(getAuditLogsProvider).call();

  DateTime? _latest<T>(
    Iterable<T> list,
    DateTime Function(T) extractor,
  ) {
    if (list.isEmpty) return null;
    return list.map(extractor).reduce(
          (a, b) => a.isAfter(b) ? a : b,
        );
  }

  return SystemHealthSnapshot(
    productsCount: products.length,
    inventoryCount: inventory.length,
    salesCount: sales.length,
    usersCount: users.length,
    auditLogsCount: audits.length,
    lastProductUpdate: _latest<ProductEntity>(
      products,
      (p) => p.updatedAt,
    ),
    lastInventoryUpdate: _latest<InventoryEntity>(
      inventory,
      (i) => i.updatedAt,
    ),
    lastSale: _latest<SaleEntity>(
      sales,
      (s) => s.createdAt,
    ),
    lastAuditLog: _latest<AuditLogEntity>(
      audits,
      (a) => a.timestamp,
    ),
  );
});
