import '../entities/auditor_access_entity.dart';

abstract class AuditorAccessRepository {
  Future<AuditorAccessEntity?> getAccess(String userId);
  Future<void> grant(AuditorAccessEntity access);
  Future<void> revoke(String userId);
}
