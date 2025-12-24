import '../../entities/inventory_entity.dart';
import '../../repositories/inventory_repository.dart';

class AdjustInventory {
  final InventoryRepository repository;

  AdjustInventory(this.repository);

  Future<void> call({
    required InventoryEntity current,
    required int adjustment,
  }) async {
    final newQuantity = current.quantity + adjustment;

    if (newQuantity < 0) {
      throw Exception('Inventory cannot go below zero');
    }

    final updated = InventoryEntity(
      productId: current.productId,
      storeId: current.storeId,
      quantity: newQuantity,
      updatedAt: DateTime.now(),
    );

    await repository.adjustInventory(updated);
  }
}
