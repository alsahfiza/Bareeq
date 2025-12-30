import 'package:flutter/material.dart';

class SalesPurchaseChart extends StatelessWidget {
  const SalesPurchaseChart({super.key});

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
          const _Legend(),
          const SizedBox(height: 12),
          SizedBox(
            height: 260,
            width: double.infinity,
            child: CustomPaint(
              painter: _BarChartPainter(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: const [
        Icon(Icons.bar_chart, size: 18),
        SizedBox(width: 8),
        Text(
          'Sales & Purchase',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
        Spacer(),
        _TimeChip(label: '1Y'),
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

/* ---------------- LEGEND ---------------- */

class _Legend extends StatelessWidget {
  const _Legend();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        _LegendItem(color: Color(0xFFFFA44C), label: 'Total Sales'),
        SizedBox(width: 16),
        _LegendItem(color: Color(0xFFFFD7B2), label: 'Total Purchase'),
      ],
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration:
              BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12)),
      ],
    );
  }
}

/* ---------------- TIME CHIP ---------------- */

class _TimeChip extends StatelessWidget {
  final String label;

  const _TimeChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFA44C),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/* ---------------- PAINTER ---------------- */

class _BarChartPainter extends CustomPainter {
  final List<double> sales = [60, 55, 40, 70, 65, 68, 45, 52, 88, 60, 75, 54];
  final List<double> purchase = [30, 28, 22, 32, 30, 29, 25, 27, 35, 30, 33, 26];

  @override
  void paint(Canvas canvas, Size size) {
    final barWidth = 14.0;
    final maxValue = 100.0;
    final spacing = (size.width - (barWidth * sales.length)) /
        (sales.length + 1);

    final paintSales = Paint()..color = const Color(0xFFFFA44C);
    final paintPurchase = Paint()..color = const Color(0xFFFFD7B2);

    for (int i = 0; i < sales.length; i++) {
      final x = spacing + i * (barWidth + spacing);

      final purchaseH = (purchase[i] / maxValue) * size.height * 0.9;
      final salesH = (sales[i] / maxValue) * size.height * 0.9;

      // Purchase (bottom)
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x,
            size.height - purchaseH,
            barWidth,
            purchaseH,
          ),
          const Radius.circular(6),
        ),
        paintPurchase,
      );

      // Sales (top)
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(
            x,
            size.height - purchaseH - salesH,
            barWidth,
            salesH,
          ),
          const Radius.circular(8),
        ),
        paintSales,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
