class SystemHealthSnapshot {
  final int productsCount;
  final int inventoryCount;
  final int salesCount;
  final int usersCount;
  final int auditLogsCount;

  final DateTime? lastProductUpdate;
  final DateTime? lastInventoryUpdate;
  final DateTime? lastSale;
  final DateTime? lastAuditLog;

  const SystemHealthSnapshot({
    required this.productsCount,
    required this.inventoryCount,
    required this.salesCount,
    required this.usersCount,
    required this.auditLogsCount,
    required this.lastProductUpdate,
    required this.lastInventoryUpdate,
    required this.lastSale,
    required this.lastAuditLog,
  });
}
