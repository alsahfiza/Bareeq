import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_entity.dart';
import '../../../core/config/user_providers.dart';
import '../../../core/config/audit_providers.dart';

class UserFormPage extends ConsumerStatefulWidget {
  const UserFormPage({super.key});

  @override
  ConsumerState<UserFormPage> createState() => _UserFormPageState();
}

class _UserFormPageState extends ConsumerState<UserFormPage> {
  final _email = TextEditingController();
  String _role = 'admin';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create User')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            TextField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            const SizedBox(height: 16),
            DropdownButton<String>(
              value: _role,
              items: const [
                DropdownMenuItem(value: 'admin', child: Text('Admin')),
                DropdownMenuItem(value: 'viewer', child: Text('Viewer')),
              ],
              onChanged: (v) => setState(() => _role = v!),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                final user = UserEntity(
                  id: '',
                  email: _email.text,
                  role: _role,
                  isActive: true,
                  createdAt: DateTime.now(),
                );

                await ref.read(createUserProvider).call(user);

                await ref.read(auditLogServiceProvider).log(
                  action: 'CREATE',
                  entity: 'user',
                  entityId: user.email,
                  before: {},
                  after: {
                    'email': user.email,
                    'role': user.role,
                    'isActive': true,
                  },
                );

                Navigator.pop(context);
              },
              child: const Text('Create'),
            ),
          ],
        ),
      ),
    );
  }
}
