import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/locks/acquire_soft_lock.dart';
import 'repository_providers.dart';

final acquireSoftLockProvider =
    Provider<AcquireSoftLock>((ref) {
  return AcquireSoftLock(
    ref.read(softLockRepositoryProvider),
  );
});
