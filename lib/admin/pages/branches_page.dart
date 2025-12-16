import 'package:flutter/material.dart';
import '../../shared/models/branch_model.dart';
import '../../shared/services/branch_service.dart';
import '../layout/admin_layout.dart';

class BranchesPage extends StatelessWidget {
  const BranchesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = BranchService();
    final nameController = TextEditingController();

    return AdminLayout(
      title: 'Branches',
      body: StreamBuilder<List<BranchModel>>(
        stream: service.getBranches(activeOnly: false),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final branches = snapshot.data!;

          return Column(
            children: [
              ElevatedButton(
                child: const Text('Add Branch'),
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('New Branch'),
                      content: TextField(
                        controller: nameController,
                        decoration:
                            const InputDecoration(labelText: 'Name'),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Cancel'),
                        ),
                        ElevatedButton(
                          child: const Text('Save'),
                          onPressed: () async {
                            await service.addBranch(
                              BranchModel(
                                id: '',
                                name: nameController.text,
                                isActive: true,
                              ),
                            );
                            nameController.clear();
                            Navigator.pop(context);
                          },
                        ),
                      ],
                    ),
                  );
                },
              ),
              Expanded(
                child: ListView(
                  children: branches
                      .map(
                        (b) => ListTile(
                          title: Text(b.name),
                          trailing: Icon(
                            b.isActive
                                ? Icons.check_circle
                                : Icons.cancel,
                            color: b.isActive
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
