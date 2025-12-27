import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/audit_providers.dart';
import '../../../domain/entities/user_entity.dart';

class UsersTableNotifier extends StateNotifier<void> {
  final Ref ref;

  UsersTableNotifier(this.ref) : super(null);

  Future<void> toggleActive(UserEntity user) async {
    final updated = user.copyWith(isActive: !user.isActive);

    // existing save logic stays untouched

    await ref.read(auditLogServiceProvider).log(
      action: 'toggle_user_active',
      before: {'isActive': user.isActive},
      after: {'isActive': updated.isActive},
    );
  }
}
