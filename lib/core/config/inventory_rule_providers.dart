import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/inventory_rules/get_inventory_rules.dart';
import '../../domain/usecases/inventory_rules/set_inventory_rule.dart';
import 'repository_providers.dart';

final getInventoryRulesProvider =
    Provider<GetInventoryRules>((ref) {
  return GetInventoryRules(
    ref.read(inventoryRuleRepositoryProvider),
  );
});

final setInventoryRuleProvider =
    Provider<SetInventoryRule>((ref) {
  return SetInventoryRule(
    ref.read(inventoryRuleRepositoryProvider),
  );
});
