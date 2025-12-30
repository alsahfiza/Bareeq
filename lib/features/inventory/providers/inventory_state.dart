import '../../../domain/entities/inventory_entity.dart';

class InventoryState {
  final bool loading;
  final List<InventoryEntity> items;
  final String? error;

  const InventoryState({
    required this.loading,
    required this.items,
    this.error,
  });

  factory InventoryState.initial() {
    return const InventoryState(
      loading: false,
      items: [],
      error: null,
    );
  }

  InventoryState copyWith({
    bool? loading,
    List<InventoryEntity>? items,
    String? error,
  }) {
    return InventoryState(
      loading: loading ?? this.loading,
      items: items ?? this.items,
      error: error,
    );
  }
}
