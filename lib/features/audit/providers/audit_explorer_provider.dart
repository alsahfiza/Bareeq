import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/audit_log_entity.dart';
import '../../../core/config/audit_explorer_providers.dart';

class AuditExplorerState {
  final List<AuditLogEntity> all;
  final List<AuditLogEntity> visible;
  final int page;
  final int pageSize;
  final String? entity;
  final String? user;
  final DateTime? from;
  final DateTime? to;

  const AuditExplorerState({
    required this.all,
    required this.visible,
    required this.page,
    required this.pageSize,
    this.entity,
    this.user,
    this.from,
    this.to,
  });

  AuditExplorerState copyWith({
    List<AuditLogEntity>? all,
    List<AuditLogEntity>? visible,
    int? page,
    int? pageSize,
    String? entity,
    String? user,
    DateTime? from,
    DateTime? to,
  }) {
    return AuditExplorerState(
      all: all ?? this.all,
      visible: visible ?? this.visible,
      page: page ?? this.page,
      pageSize: pageSize ?? this.pageSize,
      entity: entity ?? this.entity,
      user: user ?? this.user,
      from: from ?? this.from,
      to: to ?? this.to,
    );
  }
}

final auditExplorerProvider =
    StateNotifierProvider<AuditExplorerNotifier, AuditExplorerState>((ref) {
  return AuditExplorerNotifier(ref);
});

class AuditExplorerNotifier extends StateNotifier<AuditExplorerState> {
  final Ref ref;

  AuditExplorerNotifier(this.ref)
      : super(const AuditExplorerState(
          all: [],
          visible: [],
          page: 0,
          pageSize: 20,
        )) {
    _load();
  }

  Future<void> _load() async {
    final logs = await ref.read(getAuditLogsProvider).call();
    state = state.copyWith(all: logs, page: 0);
    _apply();
  }

  void setEntity(String? v) {
    state = state.copyWith(entity: v, page: 0);
    _apply();
  }

  void setUser(String? v) {
    state = state.copyWith(user: v, page: 0);
    _apply();
  }

  void setFrom(DateTime? v) {
    state = state.copyWith(from: v, page: 0);
    _apply();
  }

  void setTo(DateTime? v) {
    state = state.copyWith(to: v, page: 0);
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
    Iterable<AuditLogEntity> data = state.all;

    if (state.entity != null && state.entity!.isNotEmpty) {
      data = data.where((l) => l.entity == state.entity);
    }

    if (state.user != null && state.user!.isNotEmpty) {
      data = data.where((l) => l.performedBy == state.user);
    }

    if (state.from != null) {
      data = data.where((l) => l.timestamp.isAfter(state.from!));
    }

    if (state.to != null) {
      data = data.where((l) => l.timestamp.isBefore(state.to!));
    }

    final filtered = data.toList();
    final start = state.page * state.pageSize;
    final end = (start + state.pageSize).clamp(0, filtered.length);

    state = state.copyWith(
      visible: filtered.sublist(start, end),
    );
  }
}
