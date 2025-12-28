import '../entities/inventory_entity.dart';

abstract class InventoryRepository {
  Future<List<InventoryEntity>> getInventory();
  Future<void> adjustStock(String productId, int delta);
}
