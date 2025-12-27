import '../../entities/data_snapshot_entity.dart';
import '../../repositories/data_snapshot_repository.dart';

class CreateDataSnapshot {
  final DataSnapshotRepository repository;

  CreateDataSnapshot(this.repository);

  Future<void> call(DataSnapshotEntity snapshot) {
    return repository.create(snapshot);
  }
}
