import 'package:flutter/material.dart';

class TopCustomersPanel extends StatelessWidget {
  const TopCustomersPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Top Customers',
      child: Column(
        children: const [
          _Row(name: 'Carlos Curran', amount: '\$8,964'),
          _Divider(),
          _Row(name: 'Stan Gaunter', amount: '\$6,985'),
          _Divider(),
          _Row(name: 'Richard Wilson', amount: '\$5,366'),
          _Divider(),
          _Row(name: 'Mary Bronson', amount: '\$4,569'),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String name;
  final String amount;

  const _Row({
    required this.name,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: const Color(0xFFEFF3FF),
            child: Text(
              name[0],
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              name,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
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
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}