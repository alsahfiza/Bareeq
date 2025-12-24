import '../../entities/system_settings_entity.dart';
import '../../repositories/system_settings_repository.dart';

class UpdateSystemSettings {
  final SystemSettingsRepository repository;

  UpdateSystemSettings(this.repository);

  Future<void> call(SystemSettingsEntity settings) {
    return repository.updateSettings(settings);
  }
}
