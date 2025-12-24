import '../../domain/entities/inventory_entity.dart';
import '../../domain/repositories/inventory_repository.dart';
import '../datasources/firestore/inventory_firestore_datasource.dart';
import '../models/inventory_model.dart';

class InventoryRepositoryImpl implements InventoryRepository {
  final InventoryFirestoreDatasource datasource;

  InventoryRepositoryImpl(this.datasource);

  @override
  Future<List<InventoryEntity>> getInventory() async {
    final models = await datasource.getInventory();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> adjustInventory(InventoryEntity inventory) async {
    final model = InventoryModel(
      productId: inventory.productId,
      storeId: inventory.storeId,
      quantity: inventory.quantity,
      updatedAt: inventory.updatedAt,
    );

    final inventoryId = '${inventory.storeId}_${inventory.productId}';

    await datasource.updateInventory(inventoryId, model);
  }
}
