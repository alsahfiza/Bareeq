import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/approval_request_entity.dart';
import '../../../core/config/approval_providers.dart';

final pendingApprovalsProvider =
    FutureProvider<List<ApprovalRequestEntity>>((ref) async {
  return ref.read(approvalRepositoryProvider).getPending();
});
