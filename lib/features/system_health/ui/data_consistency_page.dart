import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/data_consistency_provider.dart';

class DataConsistencyPage extends ConsumerWidget {
  const DataConsistencyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(dataConsistencyProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text(e.toString()),
        data: (issues) {
          if (issues.isEmpty) {
            return const Text(
              'No data consistency issues detected.',
              style: TextStyle(fontSize: 16),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Data Consistency Warnings',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView.separated(
                  itemCount: issues.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 16),
                  itemBuilder: (_, i) {
                    final issue = issues[i];
                    return ListTile(
                      leading: const Icon(
                        Icons.warning,
                        color: Colors.orange,
                      ),
                      title: Text(issue.type),
                      subtitle: Text(issue.message),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
