import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/usecase_providers.dart';
import '../../../domain/entities/audit_log_entity.dart';
import 'audit_intelligence_models.dart';

class AuditIntelligenceState {
  final List<UserAuditSummary> byUser;
  final List<EntityAuditSummary> byEntity;
  final List<DailyAuditSummary> byDay;

  const AuditIntelligenceState({
    required this.byUser,
    required this.byEntity,
    required this.byDay,
  });
}

final auditIntelligenceProvider =
    FutureProvider<AuditIntelligenceState>((ref) async {
  final logs = await ref.read(getAuditLogsProvider).call();

  final Map<String, int> userMap = {};
  final Map<String, int> entityMap = {};
  final Map<String, int> dayMap = {};

  for (final AuditLogEntity l in logs) {
    userMap[l.performedBy] =
        (userMap[l.performedBy] ?? 0) + 1;

    entityMap[l.entity] =
        (entityMap[l.entity] ?? 0) + 1;

    final day =
        l.timestamp.toIso8601String().split('T').first;
    dayMap[day] = (dayMap[day] ?? 0) + 1;
  }

  final byUser = userMap.entries
      .map((e) => UserAuditSummary(
            userId: e.key,
            actions: e.value,
          ))
      .toList()
    ..sort((a, b) => b.actions.compareTo(a.actions));

  final byEntity = entityMap.entries
      .map((e) => EntityAuditSummary(
            entity: e.key,
            actions: e.value,
          ))
      .toList()
    ..sort((a, b) => b.actions.compareTo(a.actions));

  final byDay = dayMap.entries
      .map((e) => DailyAuditSummary(
            day: e.key,
            actions: e.value,
          ))
      .toList()
    ..sort((a, b) => b.day.compareTo(a.day));

  return AuditIntelligenceState(
    byUser: byUser,
    byEntity: byEntity,
    byDay: byDay,
  );
});
