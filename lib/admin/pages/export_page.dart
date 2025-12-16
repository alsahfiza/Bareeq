import 'package:flutter/material.dart';
import '../../shared/services/csv_export_service.dart';
import '../layout/admin_layout.dart';

class ExportPage extends StatelessWidget {
  const ExportPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = CsvExportService();

    return AdminLayout(
      title: 'Export Data',
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Export CSV',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            ElevatedButton.icon(
              icon: const Icon(Icons.inventory),
              label: const Text('Export Products'),
              onPressed: () async {
                final file = await service.exportProducts();
                _showResult(context, file.path);
              },
            ),

            const SizedBox(height: 16),

            ElevatedButton.icon(
              icon: const Icon(Icons.receipt_long),
              label: const Text('Export Orders'),
              onPressed: () async {
                final file = await service.exportOrders();
                _showResult(context, file.path);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showResult(BuildContext context, String path) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('CSV saved to: $path'),
        duration: const Duration(seconds: 5),
      ),
    );
  }
}
