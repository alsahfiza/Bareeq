import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/system_settings_entity.dart';
import '../../../core/config/system_settings_providers.dart';

class SystemSettingsState {
  final SystemSettingsEntity? settings;
  final bool loading;

  const SystemSettingsState({
    required this.settings,
    required this.loading,
  });

  SystemSettingsState copyWith({
    SystemSettingsEntity? settings,
    bool? loading,
  }) {
    return SystemSettingsState(
      settings: settings ?? this.settings,
      loading: loading ?? this.loading,
    );
  }
}

final systemSettingsProvider =
    StateNotifierProvider<SystemSettingsNotifier, SystemSettingsState>((ref) {
  return SystemSettingsNotifier(ref);
});

class SystemSettingsNotifier
    extends StateNotifier<SystemSettingsState> {
  final Ref ref;

  SystemSettingsNotifier(this.ref)
      : super(const SystemSettingsState(
          settings: null,
          loading: true,
        )) {
    _load();
  }

  Future<void> _load() async {
    final s = await ref.read(getSystemSettingsProvider).call();
    state = state.copyWith(settings: s, loading: false);
  }

  Future<void> update(SystemSettingsEntity s) async {
    await ref.read(updateSystemSettingsProvider).call(s);
    await _load();
  }
}
