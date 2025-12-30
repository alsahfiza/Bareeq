import 'package:flutter/material.dart';
import '../../../../core/layout/admin_card.dart';

class OrderHeatmap extends StatelessWidget {
  const OrderHeatmap({super.key});

  static const int rows = 7;   // days
  static const int cols = 24;  // hours

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      title: 'Order Activity Heatmap',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final cellWidth = constraints.maxWidth / cols;
          final cellHeight = constraints.maxHeight / rows;

          final cellSize = cellWidth < cellHeight
              ? cellWidth
              : cellHeight;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _daysHeader(cellSize),
              const SizedBox(height: 8),
              Expanded(child: _grid(cellSize)),
            ],
          );
        },
      ),
    );
  }

  Widget _daysHeader(double cellSize) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Row(
      children: [
        const SizedBox(width: 40),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              6,
              (i) => Text(
                '${i * 4}:00',
                style: const TextStyle(fontSize: 11),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _grid(double cellSize) {
    return Row(
      children: [
        _dayLabels(),
        Expanded(
          child: GridView.builder(
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: cols,
              childAspectRatio: 1,
            ),
            itemCount: rows * cols,
            itemBuilder: (context, index) {
              final intensity = _fakeIntensity(index);
              return Container(
                margin: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: _colorFor(intensity),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _dayLabels() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: days
          .map(
            (d) => SizedBox(
              height: 22,
              child: Text(
                d,
                style: const TextStyle(fontSize: 11),
              ),
            ),
          )
          .toList(),
    );
  }

  int _fakeIntensity(int index) {
    final hour = index % cols;
    if (hour >= 9 && hour <= 18) return 3;
    if (hour >= 6 && hour <= 21) return 2;
    return 1;
  }

  Color _colorFor(int value) {
    switch (value) {
      case 3:
        return Colors.orange.shade700;
      case 2:
        return Colors.orange.shade400;
      case 1:
        return Colors.orange.shade200;
      default:
        return Colors.grey.shade200;
    }
  }
}
