import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../activity/user_activity_provider.dart';

class UserActivityTimelinePage extends ConsumerWidget {
  final String userId;

  const UserActivityTimelinePage({
    super.key,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(userActivityProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Activity Timeline'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: async.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (e, _) => Text(e.toString()),
          data: (items) {
            if (items.isEmpty) {
              return const Text(
                'No activity recorded for this user.',
                style: TextStyle(fontSize: 16),
              );
            }

            return ListView.separated(
              itemCount: items.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 24),
              itemBuilder: (_, i) {
                final item = items[i];
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.timestamp.toIso8601String(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${item.action} ${item.entity}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Entity ID: ${item.entityId}'),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
