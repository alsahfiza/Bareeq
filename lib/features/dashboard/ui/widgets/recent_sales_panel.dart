import 'package:flutter/material.dart';

class RecentSalesPanel extends StatelessWidget {
  const RecentSalesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Recent Sales',
      child: Column(
        children: const [
          _RowItem(name: 'iPhone 14 Pro', date: '12 Jun 2024', amount: '\$1,200'),
          _Divider(),
          _RowItem(name: 'Apple Watch', date: '11 Jun 2024', amount: '\$820'),
          _Divider(),
          _RowItem(name: 'AirPods Pro', date: '10 Jun 2024', amount: '\$420'),
          _Divider(),
          _RowItem(name: 'MacBook Air', date: '09 Jun 2024', amount: '\$1,450'),
        ],
      ),
    );
  }
}

class _RowItem extends StatelessWidget {
  final String name;
  final String date;
  final String amount;

  const _RowItem({
    required this.name,
    required this.date,
    required this.amount,
  });

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
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.shopping_bag, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                const SizedBox(height: 2),
                Text(date, style: const TextStyle(fontSize: 11, color: Colors.black45)),
              ],
            ),
          ),
          Text(
            amount,
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

  const _Card({
    required this.title,
    required this.child,
  });

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
              const Text('View All',
                  style: TextStyle(fontSize: 11, color: Color(0xFF2563EB))),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
