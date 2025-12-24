import '../../entities/inventory_entity.dart';
import '../../repositories/inventory_repository.dart';

class GetInventory {
  final InventoryRepository repository;

  GetInventory(this.repository);

  Future<List<InventoryEntity>> call() {
    return repository.getInventory();
  }
}
