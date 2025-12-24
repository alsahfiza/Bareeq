import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final String title;
  final String value;
  final double trend;

  const KpiCard({
    required this.title,
    required this.value,
    required this.trend,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final up = trend >= 0;
    final color = up ? Colors.green : Colors.red;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 6),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.black54,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                up ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: color,
              ),
              const SizedBox(width: 4),
              Text(
                '${trend.toStringAsFixed(1)}%',
                style: TextStyle(color: color),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
