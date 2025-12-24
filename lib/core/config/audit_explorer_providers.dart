import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/usecases/audit/get_audit_logs.dart';
import 'repository_providers.dart';

final getAuditLogsProvider = Provider<GetAuditLogs>((ref) {
  return GetAuditLogs(ref.read(auditRepositoryProvider));
});
