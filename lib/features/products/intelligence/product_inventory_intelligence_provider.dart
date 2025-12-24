import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/product_entity.dart';
import '../../../domain/entities/inventory_entity.dart';
import '../../../core/config/usecase_providers.dart';
import 'product_inventory_intelligence.dart';

final productInventoryIntelligenceProvider =
    FutureProvider<List<ProductInventoryIntelligence>>((ref) async {
  final products = await ref.read(getProductsProvider).call();
  final inventory = await ref.read(getInventoryProvider).call();

  final Map<String, List<InventoryEntity>> inventoryByProduct = {};

  for (final i in inventory) {
    inventoryByProduct.putIfAbsent(i.productId, () => []).add(i);
  }

  final List<ProductInventoryIntelligence> result = [];

  for (final p in products) {
    final items = inventoryByProduct[p.id] ?? [];
    final Map<String, int> byStore = {};
    int total = 0;

    for (final i in items) {
      byStore[i.storeId] = i.quantity;
      total += i.quantity;
    }

    final severity = total <= 5
        ? StockSeverity.critical
        : total <= 15
            ? StockSeverity.warning
            : StockSeverity.ok;

    result.add(
      ProductInventoryIntelligence(
        productId: p.id,
        productName: p.name,
        stockByStore: byStore,
        totalStock: total,
        severity: severity,
      ),
    );
  }

  return result;
});
