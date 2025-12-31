import 'package:flutter/material.dart';

class LowStockPanel extends StatelessWidget {
  const LowStockPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Low Stock Products',
      child: Column(
        children: const [
          _Item(name: 'Samsung TV', stock: '8'),
          _Divider(),
          _Item(name: 'Logitech Mouse', stock: '12'),
          _Divider(),
          _Item(name: 'Sony Headphones', stock: '5'),
          _Divider(),
          _Item(name: 'HP Printer', stock: '9'),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  final String name;
  final String stock;

  const _Item({required this.name, required this.stock});

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
              color: const Color(0xFFFFF3E9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.inventory_2, size: 16, color: Color(0xFFFF8A00)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFFECEC),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              stock,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFFE4572E),
              ),
            ),
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
