import 'package:flutter/material.dart';

class KpiCard extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final double value;
  final String delta;
  final Color deltaColor;

  const KpiCard({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    required this.value,
    required this.delta,
    required this.deltaColor,
  });

  // ── Factory constructors (clean API)
  factory KpiCard.totalSales(double v) => KpiCard(
        icon: Icons.shopping_cart,
        color: Colors.orange,
        title: 'Total Sales',
        value: v,
        delta: '+22%',
        deltaColor: Colors.green,
      );

  factory KpiCard.salesReturn(double v) => KpiCard(
        icon: Icons.undo,
        color: Colors.blueGrey,
        title: 'Sales Return',
        value: v,
        delta: '-12%',
        deltaColor: Colors.red,
      );

  factory KpiCard.totalPurchase(double v) => KpiCard(
        icon: Icons.shopping_bag,
        color: Colors.teal,
        title: 'Total Purchase',
        value: v,
        delta: '+18%',
        deltaColor: Colors.green,
      );

  factory KpiCard.purchaseReturn(double v) => KpiCard(
        icon: Icons.assignment_return,
        color: Colors.indigo,
        title: 'Purchase Return',
        value: v,
        delta: '+8%',
        deltaColor: Colors.green,
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 12),
          Text(
            title,
            style: const TextStyle(fontSize: 13),
          ),
          const SizedBox(height: 6),
          Text(
            '\$${value.toStringAsFixed(2)}',
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: deltaColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              delta,
              style: TextStyle(
                color: deltaColor,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
