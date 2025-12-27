import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'repository_providers.dart';

final auditorAccessRepositoryProvider =
    Provider((ref) => ref.read(auditorAccessRepositoryProvider));

final auditorAccessProvider =
    FutureProvider.family((ref, String userId) {
  return ref
      .read(auditorAccessRepositoryProvider)
      .getAccess(userId);
});
