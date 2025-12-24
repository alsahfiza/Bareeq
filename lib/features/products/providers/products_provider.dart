Future<void> updateProduct(ProductEntity updated) async {
  try {
    final currentState = state;

    if (currentState is! ProductsReady) return;

    final existing = currentState.products
        .firstWhere((p) => p.id == updated.id);

    await ref.read(updateProductProvider).call(updated);

    await ref.read(auditLogServiceProvider).log(
      action: 'UPDATE',
      entity: 'product',
      entityId: updated.id,
      before: {
        'price': existing.price,
        'cost': existing.cost,
        'isActive': existing.isActive,
      },
      after: {
        'price': updated.price,
        'cost': updated.cost,
        'isActive': updated.isActive,
      },
    );

    await load();
  } catch (e) {
    state = ProductsError(e.toString());
  }
}
