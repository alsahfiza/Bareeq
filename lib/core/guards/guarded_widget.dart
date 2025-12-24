import 'package:flutter/widgets.dart';
import '../../domain/entities/user_entity.dart';
import 'role_guard.dart';

class GuardedWidget extends StatelessWidget {
  final UserEntity user;
  final bool Function(RoleGuard guard) allow;
  final Widget child;
  final Widget? fallback;

  const GuardedWidget({
    required this.user,
    required this.allow,
    required this.child,
    this.fallback,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final guard = RoleGuard(user);

    if (!guard.isActive || !allow(guard)) {
      return fallback ?? const SizedBox.shrink();
    }

    return child;
  }
}
