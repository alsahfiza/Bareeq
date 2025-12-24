import '../../domain/entities/inventory_rule_entity.dart';
import '../../domain/repositories/inventory_rule_repository.dart';
import '../datasources/firestore/inventory_rule_firestore_datasource.dart';
import '../models/inventory_rule_model.dart';

class InventoryRuleRepositoryImpl
    implements InventoryRuleRepository {
  final InventoryRuleFirestoreDatasource datasource;

  InventoryRuleRepositoryImpl(this.datasource);

  @override
  Future<int> getDefaultMinimumStock() {
    return datasource.getDefaultMinimumStock();
  }

  @override
  Future<void> setDefaultMinimumStock(int value) {
    return datasource.setDefaultMinimumStock(value);
  }

  @override
  Future<List<InventoryRuleEntity>> getRules() async {
    final models = await datasource.getRules();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> upsertRule(InventoryRuleEntity rule) {
    return datasource.upsertRule(
      InventoryRuleModel.fromEntity(rule),
    );
  }
}
