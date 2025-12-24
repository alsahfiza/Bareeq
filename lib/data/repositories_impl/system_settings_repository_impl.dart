import '../../domain/entities/system_settings_entity.dart';
import '../../domain/repositories/system_settings_repository.dart';
import '../datasources/firestore/system_settings_firestore_datasource.dart';
import '../models/system_settings_model.dart';

class SystemSettingsRepositoryImpl
    implements SystemSettingsRepository {
  final SystemSettingsFirestoreDatasource datasource;

  SystemSettingsRepositoryImpl(this.datasource);

  @override
  Future<SystemSettingsEntity> getSettings() async {
    final model = await datasource.get();
    return model.toEntity();
  }

  @override
  Future<void> updateSettings(
    SystemSettingsEntity settings,
  ) {
    return datasource.update(
      SystemSettingsModel.fromEntity(settings),
    );
  }
}
