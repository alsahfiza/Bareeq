import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/inventory_entity.dart';
import '../../../core/config/usecase_providers.dart';
import '../../../core/config/audit_providers.dart';

class InventoryTableState {
  final List<InventoryEntity> all;
  final List<InventoryEntity> visible;
  final int page;
  final int pageSize;

  const InventoryTableState({
    required this.all,
    required this.visible,
    required this.page,
    required this.pageSize,
  });

  InventoryTableState copyWith({
    List<InventoryEntity>? all,
    List<InventoryEntity>? visible,
    int? page,
    int? pageSize,
  }) {
    return InventoryTableState(
      all: all ?? this.all,
      visible: visible ?? this.visible,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

final inventoryTableProvider =
    StateNotifierProvider<InventoryTableNotifier, InventoryTableState>((ref) {
  return InventoryTableNotifier(ref);
});

class InventoryTableNotifier extends StateNotifier<InventoryTableState> {
  final Ref ref;

  InventoryTableNotifier(this.ref)
      : super(const InventoryTableState(
          all: [],
          visible: [],
          page: 0,
          pageSize: 10,
        )) {
    _load();
  }

  Future<void> _load() async {
    final inventory = await ref.read(getInventoryProvider).call();
    state = state.copyWith(all: inventory);
    _apply();
  }

  void nextPage() {
    state = state.copyWith(page: state.page + 1);
    _apply();
  }

  void prevPage() {
    if (state.page == 0) return;
    state = state.copyWith(page: state.page - 1);
    _apply();
  }

  Future<void> adjust({
    required InventoryEntity current,
    required int delta,
  }) async {
    await ref.read(adjustInventoryProvider).call(
          current: current,
          adjustment: delta,
        );

    await ref.read(auditLogServiceProvider).log(
      action: 'ADJUST',
      entity: 'inventory',
      entityId: '${current.storeId}_${current.productId}',
      before: {'quantity': current.quantity},
      after: {'quantity': current.quantity + delta},
    );

    await _load();
  }

  void _apply() {
    final start = state.page * state.pageSize;
    final end = (start + state.pageSize).clamp(0, state.all.length);

    state = state.copyWith(
      visible: state.all.sublist(start, end),
    );
  }
}
