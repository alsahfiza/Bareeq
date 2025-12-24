import '../../domain/entities/soft_lock_entity.dart';
import '../../domain/repositories/soft_lock_repository.dart';
import '../datasources/firestore/soft_lock_firestore_datasource.dart';
import '../models/soft_lock_model.dart';

class SoftLockRepositoryImpl implements SoftLockRepository {
  final SoftLockFirestoreDatasource datasource;

  SoftLockRepositoryImpl(this.datasource);

  @override
  Future<SoftLockEntity?> getLock(
    String entityType,
    String entityId,
  ) async {
    final model = await datasource.getLock(entityType, entityId);
    return model?.toEntity();
  }

  @override
  Future<void> acquireLock(SoftLockEntity lock) {
    return datasource.acquireLock(
      SoftLockModel.fromEntity(lock),
    );
  }
}
