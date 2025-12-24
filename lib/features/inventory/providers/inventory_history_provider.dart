import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/audit_log_entity.dart';
import '../../../core/config/audit_history_providers.dart';

class InventoryHistoryState {
  final List<AuditLogEntity> all;
  final List<AuditLogEntity> visible;
  final int page;
  final int pageSize;

  const InventoryHistoryState({
    required this.all,
    required this.visible,
    required this.page,
    required this.pageSize,
  });

  InventoryHistoryState copyWith({
    List<AuditLogEntity>? all,
    List<AuditLogEntity>? visible,
    int? page,
    int? pageSize,
  }) {
    return InventoryHistoryState(
      all: all ?? this.all,
      visible: visible ?? this.visible,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
    );
  }
}

final inventoryHistoryProvider =
    StateNotifierProvider<InventoryHistoryNotifier, InventoryHistoryState>((ref) {
  return InventoryHistoryNotifier(ref);
});

class InventoryHistoryNotifier
    extends StateNotifier<InventoryHistoryState> {
  final Ref ref;

  InventoryHistoryNotifier(this.ref)
      : super(const InventoryHistoryState(
          all: [],
          visible: [],
          page: 0,
          pageSize: 15,
        )) {
    _load();
  }

  Future<void> _load() async {
    final logs =
        await ref.read(getInventoryAdjustmentLogsProvider).call();
    state = state.copyWith(all: logs);
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

  void _apply() {
    final start = state.page * state.pageSize;
    final end = (start + state.pageSize).clamp(0, state.all.length);
    state = state.copyWith(
      visible: state.all.sublist(start, end),
    );
  }
}
