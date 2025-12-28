import 'package:flutter_riverpod/flutter_riverpod.dart';

final systemHealthProvider =
    FutureProvider<SystemHealth>((ref) async {
  return SystemHealth.empty();
});

class SystemHealth {
  final int productsCount;
  final int inventoryCount;
  final int salesCount;
  final int usersCount;
  final int auditLogsCount;

  final DateTime? lastProductUpdate;
  final DateTime? lastInventoryUpdate;
  final DateTime? lastSale;
  final DateTime? lastAuditLog;

  const SystemHealth({
    required this.productsCount,
    required this.inventoryCount,
    required this.salesCount,
    required this.usersCount,
    required this.auditLogsCount,
    this.lastProductUpdate,
    this.lastInventoryUpdate,
    this.lastSale,
    this.lastAuditLog,
  });

  factory SystemHealth.empty() => const SystemHealth(
        productsCount: 0,
        inventoryCount: 0,
        salesCount: 0,
        usersCount: 0,
        auditLogsCount: 0,
      );
}
