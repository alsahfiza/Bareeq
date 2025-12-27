import '../../entities/approval_request_entity.dart';
import '../../repositories/approval_repository.dart';

class ReviewApprovalRequest {
  final ApprovalRepository repository;

  ReviewApprovalRequest(this.repository);

  Future<void> call(ApprovalRequestEntity request) {
    return repository.update(request);
  }
}
