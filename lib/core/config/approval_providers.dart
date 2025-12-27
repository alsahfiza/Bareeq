import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/approvals/create_approval_request.dart';
import '../../domain/usecases/approvals/review_approval_request.dart';
import 'repository_providers.dart';

final createApprovalRequestProvider =
    Provider<CreateApprovalRequest>((ref) {
  return CreateApprovalRequest(
    ref.read(approvalRepositoryProvider),
  );
});

final reviewApprovalRequestProvider =
    Provider<ReviewApprovalRequest>((ref) {
  return ReviewApprovalRequest(
    ref.read(approvalRepositoryProvider),
  );
});
