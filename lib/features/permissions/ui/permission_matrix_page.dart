import 'package:flutter/material.dart';
import '../../../core/config/permission_matrix_data.dart';

class PermissionMatrixPage extends StatelessWidget {
  const PermissionMatrixPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Role & Permission Matrix',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Feature')),
                  DataColumn(label: Text('Viewer')),
                  DataColumn(label: Text('Admin')),
                  DataColumn(label: Text('Super Admin')),
                ],
                rows: [
                  for (final p in permissionMatrixData)
                    DataRow(
                      cells: [
                        DataCell(Text(p.feature)),
                        DataCell(_icon(p.viewer)),
                        DataCell(_icon(p.admin)),
                        DataCell(_icon(p.superAdmin)),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _icon(bool allowed) {
    return Icon(
      allowed ? Icons.check_circle : Icons.block,
      color: allowed ? Colors.green : Colors.red,
    );
  }
}
