import 'package:flutter/material.dart';

class SalesPurchasePanel extends StatelessWidget {
  const SalesPurchasePanel({super.key});

  @override
  Widget build(BuildContext context) {
    final sales = [60, 52, 40, 68, 62, 65, 45, 55, 80, 60, 70, 55];
    final purchase = [25, 28, 22, 30, 27, 26, 23, 25, 29, 27, 28, 26];

    return _Card(
      title: 'Sales & Purchase',
      trailing: _RangeSelector(),
      child: SizedBox(
        height: 260,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: List.generate(sales.length, (i) {
            return Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _Bar(
                    height: sales[i].toDouble(),
                    color: const Color(0xFFFFA44C),
                  ),
                  const SizedBox(height: 6),
                  _Bar(
                    height: purchase[i].toDouble(),
                    color: const Color(0xFFFFD8B5),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

/* ────────── PARTS ────────── */

class _Bar extends StatelessWidget {
  final double height;
  final Color color;

  const _Bar({required this.height, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 14,
      height: height * 2,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
    );
  }
}

class _RangeSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA44C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Text(
        '1Y',
        style: TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _Card({
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
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
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}
