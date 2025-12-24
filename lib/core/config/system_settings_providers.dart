import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/system_settings/get_system_settings.dart';
import '../../domain/usecases/system_settings/update_system_settings.dart';
import 'repository_providers.dart';

final getSystemSettingsProvider =
    Provider<GetSystemSettings>((ref) {
  return GetSystemSettings(
    ref.read(systemSettingsRepositoryProvider),
  );
});

final updateSystemSettingsProvider =
    Provider<UpdateSystemSettings>((ref) {
  return UpdateSystemSettings(
    ref.read(systemSettingsRepositoryProvider),
  );
});
