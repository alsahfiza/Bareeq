import '../../../domain/entities/auditor_access_entity.dart';

class AuditorGuard {
  static bool canAccess(AuditorAccessEntity? access) {
    if (access == null) return false;
    return !access.isExpired;
  }
}
