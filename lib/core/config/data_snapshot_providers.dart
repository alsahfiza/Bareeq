import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/snapshots/create_data_snapshot.dart';
import '../../domain/usecases/snapshots/get_snapshots_by_type.dart';
import 'repository_providers.dart';

final createDataSnapshotProvider =
    Provider<CreateDataSnapshot>((ref) {
  return CreateDataSnapshot(
    ref.read(dataSnapshotRepositoryProvider),
  );
});

final getSnapshotsByTypeProvider =
    Provider<GetSnapshotsByType>((ref) {
  return GetSnapshotsByType(
    ref.read(dataSnapshotRepositoryProvider),
  );
});
