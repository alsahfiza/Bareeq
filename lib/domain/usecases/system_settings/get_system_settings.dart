import '../../entities/system_settings_entity.dart';
import '../../repositories/system_settings_repository.dart';

class GetSystemSettings {
  final SystemSettingsRepository repository;

  GetSystemSettings(this.repository);

  Future<SystemSettingsEntity> call() {
    return repository.getSettings();
  }
}
