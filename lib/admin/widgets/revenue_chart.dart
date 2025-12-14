import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class RevenueChart extends StatelessWidget {
  final Map<int, double> data;

  const RevenueChart({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final spots = data.entries
        .map((e) => FlSpot(e.key.toDouble(), e.value))
        .toList()
      ..sort((a, b) => a.x.compareTo(b.x));

    return LineChart(
      LineChartData(
        minX: 1,
        maxX: 12,
        minY: 0,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          )
        ],
        titlesData: FlTitlesData(show: true),
      ),
    );
  }
}
