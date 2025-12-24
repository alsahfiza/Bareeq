import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/audit_explorer_provider.dart';
import '../utils/audit_csv_exporter.dart';

class AuditExplorerPage extends ConsumerWidget {
  const AuditExplorerPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(auditExplorerProvider);
    final notifier = ref.read(auditExplorerProvider.notifier);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Audit Logs',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          /// Filters
          Row(
            children: [
              SizedBox(
                width: 160,
                child: TextField(
                  decoration:
                      const InputDecoration(labelText: 'Entity'),
                  onChanged: notifier.setEntity,
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 160,
                child: TextField(
                  decoration:
                      const InputDecoration(labelText: 'User'),
                  onChanged: notifier.setUser,
                ),
              ),
              const Spacer(),
              ElevatedButton(
                onPressed: () {
                  final csv = AuditCsvExporter.export(state.all);
                  final blob = html.Blob([csv]);
                  final url =
                      html.Url.createObjectUrlFromBlob(blob);
                  html.AnchorElement(href: url)
                    ..setAttribute(
                        'download', 'audit_logs.csv')
                    ..click();
                  html.Url.revokeObjectUrl(url);
                },
                child: const Text('Export CSV'),
              ),
            ],
          ),

          const SizedBox(height: 16),

          /// Table
          Expanded(
            child: SingleChildScrollView(
              child: DataTable(
                columns: const [
                  DataColumn(label: Text('Date')),
                  DataColumn(label: Text('Entity')),
                  DataColumn(label: Text('Action')),
                  DataColumn(label: Text('User')),
                ],
                rows: [
                  for (final l in state.visible)
                    DataRow(
                      cells: [
                        DataCell(Text(
                          l.timestamp
                              .toIso8601String()
                              .split('T')
                              .first,
                        )),
                        DataCell(Text(l.entity)),
                        DataCell(Text(l.action)),
                        DataCell(Text(l.performedBy)),
                      ],
                    ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 12),

          /// Pagination
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: notifier.prevPage,
                child: const Text('Previous'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: notifier.nextPage,
                child: const Text('Next'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
