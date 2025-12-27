import '../../domain/entities/auditor_access_entity.dart';
import '../../domain/repositories/auditor_access_repository.dart';
import '../datasources/firestore/auditor_access_firestore_datasource.dart';
import '../models/auditor_access_model.dart';

class AuditorAccessRepositoryImpl
    implements AuditorAccessRepository {
  final AuditorAccessFirestoreDatasource datasource;

  AuditorAccessRepositoryImpl(this.datasource);

  @override
  Future<AuditorAccessEntity?> getAccess(String userId) async {
    final model = await datasource.get(userId);
    return model?.toEntity();
  }

  @override
  Future<void> grant(AuditorAccessEntity access) {
    return datasource.grant(
      AuditorAccessModel.fromEntity(access),
    );
  }

  @override
  Future<void> revoke(String userId) {
    return datasource.revoke(userId);
  }
}
