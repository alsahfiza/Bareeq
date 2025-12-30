import 'package:flutter/material.dart';
import '../../../../core/layout/admin_card.dart';

class RecentTransactionsTable extends StatelessWidget {
  const RecentTransactionsTable({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Recent Transactions'),
          const SizedBox(height: 16),
          DataTable(
            columns: const [
              DataColumn(label: Text('Date')),
              DataColumn(label: Text('Customer')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Total')),
        ],
        rows: List.generate(5, (i) {
          return DataRow(cells: [
            const DataCell(Text('24 May')),
            DataCell(Text('Customer $i')),
            const DataCell(Chip(label: Text('Completed'))),
            const DataCell(Text('\$4,560')),
          ]);
        }),
      ),
        ],
      ),
    );
  }
}
