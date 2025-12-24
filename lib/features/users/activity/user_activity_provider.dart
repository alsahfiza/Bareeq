import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/audit_explorer_providers.dart';
import '../../../domain/entities/audit_log_entity.dart';
import 'user_activity_item.dart';

final userActivityProvider =
    FutureProvider.family<List<UserActivityItem>, String>((ref, userId) async {
  final logs = await ref.read(getAuditLogsProvider).call();

  final List<UserActivityItem> items = logs
      .where((AuditLogEntity l) => l.performedBy == userId)
      .map(
        (l) => UserActivityItem(
          timestamp: l.timestamp,
          action: l.action,
          entity: l.entity,
          entityId: l.entityId,
          before: l.before,
          after: l.after,
        ),
      )
      .toList()
    ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

  return items;
});
