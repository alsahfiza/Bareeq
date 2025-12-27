import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/config_change_history_provider.dart';

class ConfigChangeHistoryPage extends ConsumerWidget {
  const ConfigChangeHistoryPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(configChangeHistoryProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text(e.toString()),
        data: (items) {
          if (items.isEmpty) {
            return const Text(
              'No configuration changes recorded.',
            );
          }

          return ListView.separated(
            itemCount: items.length,
            separatorBuilder: (_, __) =>
                const Divider(height: 24),
            itemBuilder: (_, i) {
              final c = items[i];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        c.action,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'By ${c.performedBy} '
                        'at ${c.timestamp.toIso8601String()}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      const SizedBox(height: 12),
                      _jsonBlock('Before', c.before),
                      const SizedBox(height: 8),
                      _jsonBlock('After', c.after),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  static Widget _jsonBlock(
    String title,
    Map<String, dynamic> data,
  ) {
    final pretty = const JsonEncoder.withIndent('  ')
        .convert(data);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          color: Colors.grey.shade100,
          child: Text(
            pretty,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}
