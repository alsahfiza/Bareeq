import '../../../core/config/usecase_providers.dart';
import '../../../domain/entities/export_profile.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/entities/inventory_entity.dart';
import '../../../domain/entities/sale_entity.dart';
import '../../../domain/entities/audit_log_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ExportService {
  final Ref ref;

  ExportService(this.ref);

  Future<List<Map<String, dynamic>>> loadData(
    ExportProfileType type,
  ) async {
    switch (type) {
      case ExportProfileType.products:
        final products = await ref.read(getProductsProvider).call();
        return products.map(_productRow).toList();

      case ExportProfileType.inventory:
        final inventory = await ref.read(getInventoryProvider).call();
        return inventory.map(_inventoryRow).toList();

      case ExportProfileType.sales:
        final sales = await ref.read(getSalesProvider).call();
        return sales.map(_saleRow).toList();

      case ExportProfileType.audit:
        final logs = await ref.read(getAuditLogsProvider).call();
        return logs.map(_auditRow).toList();
    }
  }

  Map<String, dynamic> _productRow(ProductEntity p) => {
        'id': p.id,
        'name': p.name,
        'sku': p.sku,
        'price': p.price,
        'cost': p.cost,
        'isActive': p.isActive,
      };

  Map<String, dynamic> _inventoryRow(InventoryEntity i) => {
        'productId': i.productId,
        'storeId': i.storeId,
        'quantity': i.quantity,
      };

  Map<String, dynamic> _saleRow(SaleEntity s) => {
        'id': s.id,
        'productId': s.productId,
        'quantity': s.quantity,
        'total': s.total,
        'profit': s.profit,
        'createdAt': s.createdAt.toIso8601String(),
      };

  Map<String, dynamic> _auditRow(AuditLogEntity a) => {
        'timestamp': a.timestamp.toIso8601String(),
        'entity': a.entity,
        'entityId': a.entityId,
        'action': a.action,
        'performedBy': a.performedBy,
      };
}
