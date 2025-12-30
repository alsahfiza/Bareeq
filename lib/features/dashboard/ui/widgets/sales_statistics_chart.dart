import 'package:flutter/material.dart';

class SalesStatisticsChart extends StatelessWidget {
  const SalesStatisticsChart({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 16),
          SizedBox(
            height: 220,
            width: double.infinity,
            child: CustomPaint(
              painter: _SalesStatsPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: const [
        Icon(Icons.show_chart, size: 18),
        SizedBox(width: 8),
        Text(
          'Sales Statistics',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        _Chip(label: 'Monthly'),
      ],
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(
          color: Color(0x11000000),
          blurRadius: 12,
          offset: Offset(0, 6),
        ),
      ],
    );
  }
}

/* ---------------- FILTER CHIP ---------------- */

class _Chip extends StatelessWidget {
  final String label;

  const _Chip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/* ---------------- PAINTER ---------------- */

class _SalesStatsPainter extends CustomPainter {
  final List<double> values = [
    -30,
    40,
    55,
    -20,
    70,
    45,
    -15,
    60,
    80,
    -25,
    50,
    65,
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = size.width / (values.length * 1.8);
    final midY = size.height / 2;
    final maxValue = 100.0;

    final positivePaint = Paint()
      ..color = const Color(0xFF16A085)
      ..style = PaintingStyle.fill;

    final negativePaint = Paint()
      ..color = const Color(0xFFFFA44C)
      ..style = PaintingStyle.fill;

    final gridPaint = Paint()
      ..color = const Color(0xFFE0E0E0)
      ..strokeWidth = 1;

    // Center line
    canvas.drawLine(
      Offset(0, midY),
      Offset(size.width, midY),
      gridPaint,
    );

    for (int i = 0; i < values.length; i++) {
      final value = values[i];
      final x = i * (barWidth * 1.6) + barWidth;
      final height = (value.abs() / maxValue) * (size.height / 2 - 12);

      if (value >= 0) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              x,
              midY - height,
              barWidth,
              height,
            ),
            const Radius.circular(6),
          ),
          positivePaint,
        );
      } else {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              x,
              midY,
              barWidth,
              height,
            ),
            const Radius.circular(6),
          ),
          negativePaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
