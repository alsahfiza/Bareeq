import '../../entities/inventory_rule_entity.dart';
import '../../repositories/inventory_rule_repository.dart';

class SetInventoryRule {
  final InventoryRuleRepository repository;

  SetInventoryRule(this.repository);

  Future<void> call(InventoryRuleEntity rule) {
    return repository.upsertRule(rule);
  }
}
