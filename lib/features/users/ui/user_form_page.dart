import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../domain/entities/user_role.dart';
import '../../../core/config/audit_providers.dart';

class UserFormPage extends ConsumerStatefulWidget {
  const UserFormPage({super.key});

  @override
  ConsumerState<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends ConsumerState<UserFormPage> {
  final _emailController = TextEditingController();
  UserRole _role = UserRole.viewer;

  Future<void> _save() async {
    final user = UserEntity(
      id: UniqueKey().toString(),
      email: _emailController.text,
      isActive: true,
      role: _role,
    );

    // existing save logic stays untouched

    await ref.read(auditLogServiceProvider).log(
      action: 'create_user',
      before: {},
      after: {
        'email': user.email,
        'role': user.role.name,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text('User Form')),
    );
  }
}
