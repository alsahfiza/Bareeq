import 'package:flutter/material.dart';
import '../../shared/models/branch_inventory_model.dart';
import '../../shared/services/branch_inventory_service.dart';
import '../layout/admin_layout.dart';

class BranchInventoryPage extends StatelessWidget {
  final String branchId;
  const BranchInventoryPage({super.key, required this.branchId});

  @override
  Widget build(BuildContext context) {
    final service = BranchInventoryService();

    return AdminLayout(
      title: 'Branch Inventory',
      body: StreamBuilder<List<BranchInventory>>(
        stream: service.getInventoryByBranch(branchId),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final inventory = snapshot.data!;

          return ListView(
            children: inventory.map((i) {
              return ListTile(
                title: Text('Product: ${i.productId}'),
                subtitle: Text('Stock: ${i.stock}'),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
