import 'package:flutter/material.dart';
import 'dashboard_kpi_card.dart';

class DashboardKpiGrid extends StatelessWidget {
  const DashboardKpiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 900;
        final columns = isWide ? 4 : 2;

        return GridView.count(
          shrinkWrap: true,
          crossAxisCount: columns,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 2.8,
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            DashboardKpiCard(
              icon: Icons.shopping_cart,
              title: 'Total Sales',
              value: '\$48,988.07',
              deltaText: '+22%',
              positive: true,
              color: Colors.orange,
            ),
            DashboardKpiCard(
              icon: Icons.reply,
              title: 'Total Sales Return',
              value: '\$16,478.15',
              deltaText: '-12%',
              positive: false,
              color: Colors.blue,
            ),
            DashboardKpiCard(
              icon: Icons.shopping_bag,
              title: 'Total Purchase',
              value: '\$24,145.78',
              deltaText: '+18%',
              positive: true,
              color: Colors.teal,
            ),
            DashboardKpiCard(
              icon: Icons.assignment_return,
              title: 'Total Purchase Return',
              value: '\$18,458.74',
              deltaText: '+8%',
              positive: true,
              color: Colors.indigo,
            ),
          ],
        );
      },
    );
  }
}
