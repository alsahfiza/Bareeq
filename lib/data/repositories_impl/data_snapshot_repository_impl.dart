import '../../domain/entities/data_snapshot_entity.dart';
import '../../domain/repositories/data_snapshot_repository.dart';
import '../datasources/firestore/data_snapshot_firestore_datasource.dart';
import '../models/data_snapshot_model.dart';

class DataSnapshotRepositoryImpl implements DataSnapshotRepository {
  final DataSnapshotFirestoreDatasource datasource;

  DataSnapshotRepositoryImpl(this.datasource);

  @override
  Future<void> create(DataSnapshotEntity snapshot) {
    return datasource.create(
      DataSnapshotModel.fromEntity(snapshot),
    );
  }

  @override
  Future<List<DataSnapshotEntity>> getByType(SnapshotType type) async {
    final models = await datasource.getByType(type.name);
    return models.map((m) => m.toEntity()).toList();
  }
}
