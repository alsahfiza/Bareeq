import '../../entities/approval_request_entity.dart';
import '../../repositories/approval_repository.dart';

class CreateApprovalRequest {
  final ApprovalRepository repository;

  CreateApprovalRequest(this.repository);

  Future<void> call(ApprovalRequestEntity request) {
    return repository.create(request);
  }
}
