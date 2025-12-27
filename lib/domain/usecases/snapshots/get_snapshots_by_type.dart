import '../../entities/data_snapshot_entity.dart';
import '../../repositories/data_snapshot_repository.dart';

class GetSnapshotsByType {
  final DataSnapshotRepository repository;

  GetSnapshotsByType(this.repository);

  Future<List<DataSnapshotEntity>> call(SnapshotType type) {
    return repository.getByType(type);
  }
}
