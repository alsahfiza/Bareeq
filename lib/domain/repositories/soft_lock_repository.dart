import '../entities/soft_lock_entity.dart';

abstract class SoftLockRepository {
  Future<SoftLockEntity?> getLock(
    String entityType,
    String entityId,
  );

  Future<void> acquireLock(SoftLockEntity lock);
}
