import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/users_table_provider.dart';
import 'user_form_page.dart';

class UsersPage extends ConsumerWidget {
  const UsersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(usersTableProvider);
    final notifier = ref.read(usersTableProvider.notifier);

    if (state.loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Users',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: DataTable(
              columns: const [
                DataColumn(label: Text('Email')),
                DataColumn(label: Text('Role')),
                DataColumn(label: Text('Status')),
                DataColumn(label: Text('Action')),
              ],
              rows: [
                for (final u in state.users)
                  DataRow(
                    cells: [
                      DataCell(Text(u.email)),
                      DataCell(Text(u.role)),
                      DataCell(Text(u.isActive ? 'Active' : 'Inactive')),
                      DataCell(
                        IconButton(
                          icon: Icon(
                            u.isActive
                                ? Icons.block
                                : Icons.check_circle,
                          ),
                          onPressed: () => notifier.toggleActive(u),
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => const UserFormPage(),
                ),
              );
            },
            child: const Text('Create User'),
          ),
        ],
      ),
    );
  }
}
