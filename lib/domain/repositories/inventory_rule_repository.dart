import '../entities/inventory_rule_entity.dart';

abstract class InventoryRuleRepository {
  Future<int> getDefaultMinimumStock();
  Future<void> setDefaultMinimumStock(int value);

  Future<List<InventoryRuleEntity>> getRules();
  Future<void> upsertRule(InventoryRuleEntity rule);
}
