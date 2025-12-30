import 'package:flutter/material.dart';
import 'dashboard_kpi_card.dart';

class DashboardKpiGrid extends StatelessWidget {
  const DashboardKpiGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        int columns;
        double aspectRatio;

        if (width >= 1200) {
          columns = 4;
          aspectRatio = 3.4;
        } else if (width >= 900) {
          columns = 2;
          aspectRatio = 3.6;
        } else {
          columns = 1;
          aspectRatio = 3.8;
        }

        return GridView.count(
          crossAxisCount: columns,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: aspectRatio,
          children: const [
            DashboardKpiCard(
              title: 'Total Sales',
              value: '\$48,988,078',
              percentage: '+2.3%',
              isPositive: true,
              backgroundColor: Color(0xFFFFA44C),
              icon: Icons.receipt_long,
            ),
            DashboardKpiCard(
              title: 'Total Sales Return',
              value: '\$16,478,145',
              percentage: '-2.2%',
              isPositive: false,
              backgroundColor: Color(0xFF0A2540),
              icon: Icons.undo,
            ),
            DashboardKpiCard(
              title: 'Total Purchase',
              value: '\$24,145,789',
              percentage: '+1.7%',
              isPositive: true,
              backgroundColor: Color(0xFF16A085),
              icon: Icons.shopping_bag,
            ),
            DashboardKpiCard(
              title: 'Total Purchase Return',
              value: '\$18,458,747',
              percentage: '+2.1%',
              isPositive: true,
              backgroundColor: Color(0xFF1F66FF),
              icon: Icons.keyboard_return,
            ),
          ],
        );
      },
    );
  }
}
