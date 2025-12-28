import '../../repositories/inventory_repository.dart';

class AdjustInventory {
  final InventoryRepository repo;
  AdjustInventory(this.repo);

  Future<void> call(String productId, int delta) {
    return repo.adjustStock(productId, delta);
  }
}
  final InventoryRepository repository; --- IGNORE ---
 --- IGNORE ---
  AdjustInventory(this.repository); --- IGNORE ---
 --- IGNORE ---
  Future<void> call(InventoryEntity inventory) {
    return repository.adjustInventory(inventory);
  } --- IGNORE ---