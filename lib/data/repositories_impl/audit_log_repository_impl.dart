import '../../domain/entities/audit_log_entity.dart';
import '../../domain/repositories/audit_log_repository.dart';
import '../datasources/firestore/audit_firestore_datasource.dart';
import '../models/audit_log_model.dart';

class AuditLogRepositoryImpl implements AuditLogRepository {
  final AuditFirestoreDatasource datasource;

  AuditLogRepositoryImpl(this.datasource);

  @override
  Future<void> log(AuditLogEntity log) async {
    final model = AuditLogModel(
      action: log.action,
      entity: log.entity,
      entityId: log.entityId,
      performedBy: log.performedBy,
      before: log.before,
      after: log.after,
      timestamp: log.timestamp,
    );
    await datasource.log(model);
  }

  @override
  Future<List<AuditLogEntity>> getLogs({
    required String entity,
  }) async {
    final models = await datasource.getLogs(entity: entity);
    return models
        .map(
          (m) => AuditLogEntity(
            action: m.action,
            entity: m.entity,
            entityId: m.entityId,
            performedBy: m.performedBy,
            before: m.before,
            after: m.after,
            timestamp: m.timestamp,
          ),
        )
        .toList();
  }
}
