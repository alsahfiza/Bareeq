Future<void> adjustStock({
  required InventoryEntity current,
  required int adjustment,
}) async {
  try {
    await ref.read(adjustInventoryProvider).call(
          current: current,
          adjustment: adjustment,
        );

    await ref.read(auditLogServiceProvider).log(
      action: 'ADJUST',
      entity: 'inventory',
      entityId: '${current.storeId}_${current.productId}',
      before: {'quantity': current.quantity},
      after: {'quantity': current.quantity + adjustment},
    );

    await load();
  } catch (e) {
    state = InventoryError(e.toString());
  }
}
