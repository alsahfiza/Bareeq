import '../../entities/inventory_rule_entity.dart';
import '../../repositories/inventory_rule_repository.dart';

class GetInventoryRules {
  final InventoryRuleRepository repository;

  GetInventoryRules(this.repository);

  Future<List<InventoryRuleEntity>> call() {
    return repository.getRules();
  }
}
