import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../../../../core/layout/admin_card.dart';

class CategoryDonut extends StatelessWidget {
  const CategoryDonut({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('Top Categories'),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 50,
                sections: [
                  PieChartSectionData(value: 40, color: Colors.orange),
                  PieChartSectionData(value: 30, color: Colors.blue),
                  PieChartSectionData(value: 20, color: Colors.green),
                  PieChartSectionData(value: 10, color: Colors.grey),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
