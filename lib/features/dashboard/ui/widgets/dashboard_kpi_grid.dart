import 'package:flutter/material.dart';
import 'dashboard_kpi_card.dart';

class DashboardKpiGrid extends StatelessWidget {
  const DashboardKpiGrid({
    super.key,
    required this.children,
  });

  final List<DashboardKpiCard> children;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    int columns;
    if (width < 600) {
      columns = 1; // mobile
    } else if (width < 1024) {
      columns = 2; // tablet
    } else {
      columns = 4; // desktop
    }

    return GridView.count(
      crossAxisCount: columns,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: _aspectRatio(width),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: children,
    );
  }

  double _aspectRatio(double width) {
    if (width < 600) return 2.8;     // mobile taller cards
    if (width < 1024) return 3.2;    // tablet
    return 3.6;                      // desktop wide cards
  }
}
