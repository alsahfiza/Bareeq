import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/users_provider.dart';
import '../../../domain/entities/user_role.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(usersProvider);
    final notifier = ref.read(usersProvider.notifier);

    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Text(
                'Users',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add User'),
              ),
            ],
          ),
        ),

        const Divider(),

        Expanded(
          child: ListView.separated(
            itemCount: state.users.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final u = state.users[index];

              return ListTile(
                leading: CircleAvatar(
                  child: Text(u.name[0]),
                ),
                title: Text(u.name),
                subtitle: Text(u.email),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _roleChip(u.role),
                    const SizedBox(width: 8),
                    Switch(
                      value: u.active,
                      onChanged: (_) => notifier.toggleActive(u),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _roleChip(UserRole role) {
    Color color;
    switch (role) {
      case UserRole.admin:
        color = Colors.red;
        break;
      case UserRole.manager:
        color = Colors.orange;
        break;
      case UserRole.staff:
        color = Colors.blue;
        break;
    }

    return Chip(
      label: Text(role.label),
      backgroundColor: color.withOpacity(0.15),
      labelStyle: TextStyle(color: color),
    );
  }
}
