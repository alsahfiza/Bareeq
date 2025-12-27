import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/approval_request_entity.dart';
import '../../../core/config/approval_providers.dart';
import '../providers/pending_approvals_provider.dart';

class ApprovalQueuePage extends ConsumerWidget {
  const ApprovalQueuePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(pendingApprovalsProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text(e.toString()),
        data: (items) {
          if (items.isEmpty) {
            return const Text('No pending approvals.');
          }

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 24),
            itemBuilder: (_, i) {
              final a = items[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${a.actionType} — ${a.entityType}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text('Entity ID: ${a.entityId}'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () => _review(
                              ref,
                              a,
                              ApprovalStatus.approved,
                            ),
                            child: const Text('Approve'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            onPressed: () => _review(
                              ref,
                              a,
                              ApprovalStatus.rejected,
                            ),
                            child: const Text('Reject'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  void _review(
    WidgetRef ref,
    ApprovalRequestEntity a,
    ApprovalStatus status,
  ) async {
    await ref.read(reviewApprovalRequestProvider).call(
          a.copyWith(
            status: status,
            reviewedBy: 'super_admin',
            reviewedAt: DateTime.now(),
          ),
        );
    ref.invalidate(pendingApprovalsProvider);
  }
}
