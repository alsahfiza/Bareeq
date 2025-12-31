import 'package:flutter/material.dart';

class CategoryDonut extends StatelessWidget {
  const CategoryDonut({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Top Categories',
      child: Row(
        children: [
          // LEFT LEGEND
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Legend(color: Color(0xFFFFA44C), label: 'Electronics', value: '698'),
                SizedBox(height: 12),
                _Legend(color: Color(0xFF16A085), label: 'Fashion', value: '545'),
                SizedBox(height: 12),
                _Legend(color: Color(0xFF0A2540), label: 'Groceries', value: '456'),
              ],
            ),
          ),

          // RIGHT DONUT
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: .75,
                  strokeWidth: 16, // ⬅ thicker ring
                  color: Color(0xFFFFA44C),
                  backgroundColor: Color(0xFFF1F1F1),
                ),
                const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('100%', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text('Sales', style: TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),

          // SizedBox(
          //   width: 130,
          //   height: 130,
          //   child: Stack(
          //     alignment: Alignment.center,
          //     children: [
          //       CircularProgressIndicator(
          //         value: .75,
          //         strokeWidth: 14,
          //         color: Color(0xFFFFA44C),
          //         backgroundColor: Color(0xFFF1F1F1),
          //       ),
          //       const Column(
          //         mainAxisSize: MainAxisSize.min,
          //         children: [
          //           Text(
          //             '100%',
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //             ),
          //           ),
          //           Text(
          //             'Sales',
          //             style: TextStyle(fontSize: 11, color: Colors.grey),
          //           ),
          //         ],
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
      footer: Column(
        children: const [
          Divider(),
          SizedBox(height: 8),
          _StatRow(label: 'Total Number Of Categories', value: '698'),
          SizedBox(height: 6),
          _StatRow(label: 'Total Number Of Products', value: '7899'),
        ],
      ),
    );
  }
}

/* ================= PARTS ================= */

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
          child: Text(
            label,
            style: const TextStyle(fontSize: 12),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            label,
            style: const TextStyle(fontSize: 12, color: Colors.grey),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ],
    );
  }
}

/* ================= CARD ================= */

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? footer;

  const _Card({
    required this.title,
    required this.child,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
          if (footer != null) ...[
            const SizedBox(height: 24),
            footer!,
          ],
        ],
      ),
    );
  }
}