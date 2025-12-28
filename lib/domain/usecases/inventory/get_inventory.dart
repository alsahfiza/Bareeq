import '../../entities/inventory_entity.dart';
import '../../repositories/inventory_repository.dart';

class GetInventory {
  final InventoryRepository repo;
  GetInventory(this.repo);

  Future<List<InventoryEntity>> call() => repo.getInventory();
}
