import '../../entities/soft_lock_entity.dart';
import '../../repositories/soft_lock_repository.dart';

class AcquireSoftLock {
  final SoftLockRepository repository;

  AcquireSoftLock(this.repository);

  Future<SoftLockEntity?> call(
    String entityType,
    String entityId,
    String userId,
  ) async {
    final existing =
        await repository.getLock(entityType, entityId);

    if (existing != null && !existing.isExpired) {
      return existing;
    }

    final lock = SoftLockEntity(
      entityType: entityType,
      entityId: entityId,
      lockedBy: userId,
      expiresAt: DateTime.now().add(
        const Duration(minutes: 5),
      ),
    );

    await repository.acquireLock(lock);
    return lock;
  }
}
