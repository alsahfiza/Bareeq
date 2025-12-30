import 'package:flutter/material.dart';
import '../../../../core/layout/admin_card.dart';
import 'chart_time_filter.dart';

class SalesPurchaseChart extends StatefulWidget {
  const SalesPurchaseChart({super.key});

  @override
  State<SalesPurchaseChart> createState() => _SalesPurchaseChartState();
}

class _SalesPurchaseChartState extends State<SalesPurchaseChart> {
  ChartRange _range = ChartRange.week;

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      title: 'Sales & Purchases',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ChartTimeFilter(
            active: _range,
            onChanged: (v) => setState(() => _range = v),
          ),
          const SizedBox(height: 12),
          Expanded(child: _chartPlaceholder()),
        ],
      ),
    );
  }

  Widget _chartPlaceholder() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return CustomPaint(
          painter: _FakeLineChartPainter(),
          size: Size(constraints.maxWidth, constraints.maxHeight),
        );
      },
    );
  }
}

class _FakeLineChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final axisPaint = Paint()
      ..color = Colors.grey.shade400
      ..strokeWidth = 1;

    final salesPaint = Paint()
      ..color = Colors.orange
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final purchasePaint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    // axes
    canvas.drawLine(
        Offset(0, size.height), Offset(size.width, size.height), axisPaint);
    canvas.drawLine(Offset(0, 0), Offset(0, size.height), axisPaint);

    // fake sales line
    final salesPath = Path()
      ..moveTo(0, size.height * 0.7)
      ..lineTo(size.width * 0.3, size.height * 0.5)
      ..lineTo(size.width * 0.6, size.height * 0.4)
      ..lineTo(size.width, size.height * 0.3);

    // fake purchases line
    final purchasePath = Path()
      ..moveTo(0, size.height * 0.8)
      ..lineTo(size.width * 0.3, size.height * 0.6)
      ..lineTo(size.width * 0.6, size.height * 0.65)
      ..lineTo(size.width, size.height * 0.55);

    canvas.drawPath(salesPath, salesPaint);
    canvas.drawPath(purchasePath, purchasePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
