import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/data_snapshot_entity.dart';
import '../../../core/config/data_snapshot_providers.dart';

class SnapshotBrowserPage extends ConsumerStatefulWidget {
  const SnapshotBrowserPage({super.key});

  @override
  ConsumerState<SnapshotBrowserPage> createState() =>
      _SnapshotBrowserPageState();
}

class _SnapshotBrowserPageState
    extends ConsumerState<SnapshotBrowserPage> {
  SnapshotType _type = SnapshotType.products;

  @override
  Widget build(BuildContext context) {
    final async = ref.watch(
      FutureProvider((ref) {
        return ref.read(getSnapshotsByTypeProvider).call(_type);
      }),
    );

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Data Snapshots',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          DropdownButton<SnapshotType>(
            value: _type,
            items: SnapshotType.values
                .map(
                  (t) => DropdownMenuItem(
                    value: t,
                    child: Text(t.name),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _type = v!),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: async.when(
              loading: () =>
                  const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(e.toString()),
              data: (items) {
                if (items.isEmpty) {
                  return const Text('No snapshots found.');
                }

                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 24),
                  itemBuilder: (_, i) {
                    final s = items[i];
                    return ListTile(
                      title: Text(
                        '${s.type.name} snapshot',
                      ),
                      subtitle: Text(
                        'Created ${s.createdAt.toIso8601String()} '
                        'by ${s.createdBy}',
                      ),
                      trailing: Text(s.data.toString()),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
