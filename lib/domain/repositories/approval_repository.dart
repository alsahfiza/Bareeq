import '../entities/approval_request_entity.dart';

abstract class ApprovalRepository {
  Future<void> create(ApprovalRequestEntity request);
  Future<List<ApprovalRequestEntity>> getPending();
  Future<void> update(ApprovalRequestEntity request);
}
