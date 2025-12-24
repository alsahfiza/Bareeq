import 'dart:html' as html;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/config/export_profiles.dart';
import '../../../core/config/export_providers.dart';
import '../utils/csv_builder.dart';

class ExportCenterPage extends ConsumerWidget {
  const ExportCenterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final service = ref.read(exportServiceProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Export Center',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.separated(
              itemCount: exportProfiles.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 24),
              itemBuilder: (_, i) {
                final profile = exportProfiles[i];
                return ListTile(
                  title: Text(profile.label),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      final data =
                          await service.loadData(profile.type);
                      final csv = CsvBuilder.build(
                        profile.columns,
                        data,
                      );
                      _download(csv, '${profile.label}.csv');
                    },
                    child: const Text('Export CSV'),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _download(String csv, String name) {
    final blob = html.Blob([csv]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    html.AnchorElement(href: url)
      ..setAttribute('download', name)
      ..click();
    html.Url.revokeObjectUrl(url);
  }
}
