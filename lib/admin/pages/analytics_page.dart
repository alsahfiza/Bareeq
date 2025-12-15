import 'package:flutter/material.dart';
import '../../shared/models/analytics_model.dart';
import '../../shared/services/analytics_service.dart';
import '../layout/admin_layout.dart';

class AnalyticsPage extends StatelessWidget {
  const AnalyticsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final service = AnalyticsService();

    return AdminLayout(
      title: 'Analytics',
      body: StreamBuilder<SalesAnalytics>(
        stream: service.getAnalytics(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!;

          final topProducts = data.topProducts.entries.toList()
            ..sort((a, b) => b.value.compareTo(a.value));

          return Padding(
            padding: const EdgeInsets.all(16),
            child: ListView(
              children: [
                /// METRICS
                Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  children: [
                    _metricCard(
                      title: 'Total Revenue',
                      value: data.totalRevenue.toStringAsFixed(2),
                      icon: Icons.attach_money,
                    ),
                    _metricCard(
                      title: 'Total Orders',
                      value: data.totalOrders.toString(),
                      icon: Icons.shopping_cart,
                    ),
                    _metricCard(
                      title: 'Today Revenue',
                      value: data.todayRevenue.toStringAsFixed(2),
                      icon: Icons.today,
                    ),
                  ],
                ),

                const SizedBox(height: 30),

                /// TOP PRODUCTS
                const Text(
                  'Top Products',
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                ...topProducts.take(5).map(
                      (e) => ListTile(
                        leading: const Icon(Icons.star),
                        title: Text(e.key),
                        trailing: Text('Sold: ${e.value}'),
                      ),
                    ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _metricCard({
    required String title,
    required String value,
    required IconData icon,
  }) {
    return Card(
      elevation: 3,
      child: SizedBox(
        width: 220,
        height: 120,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 28),
              const Spacer(),
              Text(
                value,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
              Text(title),
            ],
          ),
        ),
      ),
    );
  }
}
