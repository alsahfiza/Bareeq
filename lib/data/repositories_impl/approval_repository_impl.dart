import '../../domain/entities/approval_request_entity.dart';
import '../../domain/repositories/approval_repository.dart';
import '../datasources/firestore/approval_firestore_datasource.dart';
import '../models/approval_request_model.dart';

class ApprovalRepositoryImpl implements ApprovalRepository {
  final ApprovalFirestoreDatasource datasource;

  ApprovalRepositoryImpl(this.datasource);

  @override
  Future<void> create(ApprovalRequestEntity request) {
    return datasource.create(
      ApprovalRequestModel.fromEntity(request),
    );
  }

  @override
  Future<List<ApprovalRequestEntity>> getPending() async {
    final models = await datasource.getPending();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> update(ApprovalRequestEntity request) {
    return datasource.update(
      ApprovalRequestModel.fromEntity(request),
    );
  }
}
