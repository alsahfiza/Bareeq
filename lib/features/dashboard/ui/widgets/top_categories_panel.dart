import 'package:flutter/material.dart';

class TopCategoriesPanel extends StatelessWidget {
  const TopCategoriesPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Top Categories',
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Legend(color: Color(0xFFFFA44C), label: 'Electronics', value: '698'),
                SizedBox(height: 12),
                _Legend(color: Color(0xFF16A085), label: 'Fashion', value: '545'),
                SizedBox(height: 12),
                _Legend(color: Color(0xFF2563EB), label: 'Groceries', value: '456'),
              ],
            ),
          ),
          SizedBox(
            width: 130,
            height: 130,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: .75,
                  strokeWidth: 16,
                  color: Color(0xFFFFA44C),
                  backgroundColor: Color(0xFFE5E7EB),
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('100%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Sales', style: TextStyle(fontSize: 11, color: Colors.black45)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _Legend({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(label, style: const TextStyle(fontSize: 12)),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
        ),
      ],
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
          Expanded(child: child),
        ],
      ),
    );
  }
}
