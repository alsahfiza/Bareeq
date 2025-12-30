import 'package:flutter/material.dart';

class SystemHealthPage extends StatelessWidget {
  const SystemHealthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Health',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: GridView.count(
              crossAxisCount: _columns(context),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              children: const [
                _HealthCard(
                  title: 'Products',
                  value: '120',
                  status: HealthStatus.ok,
                  lastUpdate: '2025-01-14',
                ),
                _HealthCard(
                  title: 'Inventory Records',
                  value: '340',
                  status: HealthStatus.ok,
                  lastUpdate: '2025-01-14',
                ),
                _HealthCard(
                  title: 'Sales Records',
                  value: '87',
                  status: HealthStatus.warning,
                  lastUpdate: '2025-01-12',
                ),
                _HealthCard(
                  title: 'Users',
                  value: '12',
                  status: HealthStatus.ok,
                  lastUpdate: '2025-01-10',
                ),
                _HealthCard(
                  title: 'Audit Logs',
                  value: '1,204',
                  status: HealthStatus.ok,
                  lastUpdate: '2025-01-14',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static int _columns(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    if (w < 600) return 1;
    if (w < 900) return 2;
    return 3;
  }
}

enum HealthStatus { ok, warning, error }

class _HealthCard extends StatelessWidget {
  final String title;
  final String value;
  final HealthStatus status;
  final String lastUpdate;

  const _HealthCard({
    required this.title,
    required this.value,
    required this.status,
    required this.lastUpdate,
  });

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      HealthStatus.ok => Colors.green,
      HealthStatus.warning => Colors.orange,
      HealthStatus.error => Colors.red,
    };

    final icon = switch (status) {
      HealthStatus.ok => Icons.check_circle,
      HealthStatus.warning => Icons.warning,
      HealthStatus.error => Icons.error,
    };

    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Last update: $lastUpdate',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
