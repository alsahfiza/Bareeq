import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/inventory_rule_entity.dart';
import '../../../core/config/inventory_rule_providers.dart';

class InventoryRulesState {
  final List<InventoryRuleEntity> rules;
  final bool loading;

  const InventoryRulesState({
    required this.rules,
    required this.loading,
  });

  InventoryRulesState copyWith({
    List<InventoryRuleEntity>? rules,
    bool? loading,
  }) {
    return InventoryRulesState(
      rules: rules ?? this.rules,
      loading: loading ?? this.loading,
    );
  }
}

final inventoryRulesProvider =
    StateNotifierProvider<InventoryRulesNotifier, InventoryRulesState>((ref) {
  return InventoryRulesNotifier(ref);
});

class InventoryRulesNotifier
    extends StateNotifier<InventoryRulesState> {
  final Ref ref;

  InventoryRulesNotifier(this.ref)
      : super(const InventoryRulesState(rules: [], loading: true)) {
    _load();
  }

  Future<void> _load() async {
    final rules = await ref.read(getInventoryRulesProvider).call();
    state = state.copyWith(rules: rules, loading: false);
  }

  Future<void> updateRule(
    String productId,
    int minimumStock,
  ) async {
    await ref.read(setInventoryRuleProvider).call(
          InventoryRuleEntity(
            productId: productId,
            minimumStock: minimumStock,
          ),
        );
    await _load();
  }
}
