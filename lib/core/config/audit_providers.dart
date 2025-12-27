import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../services/audit_log_service.dart';

final auditLogServiceProvider = Provider<AuditLogService>((ref) {
  return AuditLogService();
});
