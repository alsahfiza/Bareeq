import 'package:flutter/material.dart';

class SalesStatisticsPanel extends StatelessWidget {
  const SalesStatisticsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<double> revenue =
        [20, 35, 30, 28, 26, 40, 22, 30, 18, 15, 28]
            .map((e) => e.toDouble())
            .toList();

    final List<double> expense =
        [15, 28, 22, 30, 27, 20, 32, 26, 22, 30, 27]
            .map((e) => e.toDouble())
            .toList();

    return _Card(
      title: 'Sales Statistics',
      child: SizedBox(
        height: 260,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(revenue.length, (i) {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _Bar(height: revenue[i], color: const Color(0xFF16A085)),
                  const SizedBox(height: 4),
                  _Bar(height: expense[i], color: const Color(0xFFE4572E)),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class _Bar extends StatelessWidget {
  final double height;
  final Color color;

  const _Bar({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: height * 4,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(4),
      ),
    );
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
          child,
        ],
      ),
    );
  }
}
