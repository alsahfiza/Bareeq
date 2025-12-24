import '../entities/system_settings_entity.dart';

abstract class SystemSettingsRepository {
  Future<SystemSettingsEntity> getSettings();
  Future<void> updateSettings(SystemSettingsEntity settings);
}
