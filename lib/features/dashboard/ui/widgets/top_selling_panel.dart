import 'package:flutter/material.dart';

class TopSellingPanel extends StatelessWidget {
  const TopSellingPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Top Selling Products',
      child: Column(
        children: const [
          _Item(name: 'MacBook Pro', sales: '\$12,450'),
          _Divider(),
          _Item(name: 'iPhone 14', sales: '\$9,840'),
          _Divider(),
          _Item(name: 'AirPods Max', sales: '\$6,320'),
          _Divider(),
          _Item(name: 'iPad Pro', sales: '\$5,980'),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String name;
  final String sales;

  const _Item({required this.name, required this.sales});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFFEFF3FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.star, size: 16, color: Color(0xFF2563EB)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          Text(
            sales,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1);
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 320,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Color(0x14000000), blurRadius: 12, offset: Offset(0, 6)),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}