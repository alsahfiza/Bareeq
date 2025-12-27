class AuditLogService {
  Future<void> log({
    required String action,
    required Map<String, dynamic> before,
    required Map<String, dynamic> after,
  }) async {
    // persistence later
  }
}
