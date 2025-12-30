import 'package:flutter/material.dart';
import 'dart:math';

class CustomerDonut extends StatelessWidget {
  const CustomerDonut({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _decoration(),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                _Header(),
                SizedBox(height: 16),
                _Legend(),
              ],
            ),
          ),
          SizedBox(
            width: 140,
            height: 140,
            child: CustomPaint(
              painter: _DonutPainter(),
              child: const Center(
                child: _CenterText(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration _decoration() {
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

/* ---------------- HEADER ---------------- */

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.people, size: 18),
        SizedBox(width: 8),
        Text(
          'Customers',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/* ---------------- CENTER ---------------- */

class _CenterText extends StatelessWidget {
  const _CenterText();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          '4,896',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(
          'Total',
          style: TextStyle(fontSize: 11, color: Colors.grey),
        ),
      ],
    );
  }
}

/* ---------------- LEGEND ---------------- */

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: const [
        _LegendItem(
          color: Color(0xFF16A085),
          label: 'New',
          value: '65%',
        ),
        SizedBox(height: 8),
        _LegendItem(
          color: Color(0xFFFFA44C),
          label: 'Returning',
          value: '35%',
        ),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;
  final String value;

  const _LegendItem({
    required this.color,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
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
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

/* ---------------- PAINTER ---------------- */

class _DonutPainter extends CustomPainter {
  final List<double> values = [65, 35];
  final List<Color> colors = [
    Color(0xFF16A085),
    Color(0xFFFFA44C),
  ];

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 18.0;
    final center = size.center(Offset.zero);
    final radius = min(size.width, size.height) / 2 - strokeWidth / 2;

    double startAngle = -pi / 2;

    for (int i = 0; i < values.length; i++) {
      final sweepAngle = (values[i] / 100) * 2 * pi;

      final paint = Paint()
        ..color = colors[i]
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += sweepAngle;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
