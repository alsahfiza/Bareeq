import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/system_health_provider.dart';

class SystemHealthPage extends ConsumerWidget {
  const SystemHealthPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final async = ref.watch(systemHealthProvider);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Text(e.toString()),
        data: (s) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'System Health & Metadata',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _section(
                'Record Counts',
                [
                  _row('Products', s.productsCount),
                  _row('Inventory Records', s.inventoryCount),
                  _row('Sales Records', s.salesCount),
                  _row('Users', s.usersCount),
                  _row('Audit Logs', s.auditLogsCount),
                ],
              ),
              const SizedBox(height: 24),
              _section(
                'Latest Activity',
                [
                  _row(
                    'Last Product Update',
                    _fmt(s.lastProductUpdate),
                  ),
                  _row(
                    'Last Inventory Update',
                    _fmt(s.lastInventoryUpdate),
                  ),
                  _row(
                    'Last Sale',
                    _fmt(s.lastSale),
                  ),
                  _row(
                    'Last Audit Log',
                    _fmt(s.lastAuditLog),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _section(
                'Environment',
                [
                  _staticRow('App Type', 'Admin Dashboard'),
                  _staticRow('Deployment', 'Web'),
                  _staticRow('Architecture', 'Clean Architecture'),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  static Widget _section(
    String title,
    List<Widget> rows,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style:
              const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        ...rows,
      ],
    );
  }

  static Widget _row(String label, Object? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 200, child: Text(label)),
          Text(value.toString()),
        ],
      ),
    );
  }

  static Widget _staticRow(String label, String value) {
    return _row(label, value);
  }

  static String _fmt(DateTime? d) {
    if (d == null) return '—';
    return d.toIso8601String();
  }
}
