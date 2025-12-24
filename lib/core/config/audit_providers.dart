import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/config/usecase_providers.dart';
import '../../features/auth/providers/current_user_provider.dart';
import '../utils/audit_log_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';


final auditLogServiceProvider = Provider<AuditLogService>((ref) {
  final userState = ref.watch(currentUserProvider);

  if (userState is! CurrentUserReady) {
    throw Exception('User not ready for audit logging');
  }

  return AuditLogService(
    logAction: ref.read(logActionProvider),
    performedBy: userState.user.id,
  );
});