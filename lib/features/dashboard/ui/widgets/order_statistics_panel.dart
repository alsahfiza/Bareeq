import 'package:flutter/material.dart';

class OrderStatisticsPanel extends StatelessWidget {
  const OrderStatisticsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final values = List.generate(42, (i) => (i % 5) + 1);

    return _Card(
      title: 'Order Statistics',
      child: GridView.count(
        crossAxisCount: 7,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        children: values.map((v) {
          return Container(
            decoration: BoxDecoration(
              color: _color(v),
              borderRadius: BorderRadius.circular(4),
            ),
          );
        }).toList(),
      ),
    );
  }

  Color _color(int v) {
    switch (v) {
      case 1:
        return const Color(0xFFEFF3FF);
      case 2:
        return const Color(0xFFC7D2FE);
      case 3:
        return const Color(0xFF818CF8);
      case 4:
        return const Color(0xFF4F46E5);
      default:
        return const Color(0xFF312E81);
    }
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({
    required this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(child: child),
        ],
      ),
    );
  }
}
