import 'package:flutter/material.dart';

class OrderHeatmap extends StatelessWidget {
  const OrderHeatmap({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(),
          const SizedBox(height: 12),
          _weekLabels(),
          const SizedBox(height: 8),
          _grid(),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: const [
        Icon(Icons.grid_view, size: 18),
        SizedBox(width: 8),
        Text(
          'Order Statistics',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _weekLabels() {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];

    return Row(
      children: days
          .map(
            (d) => Expanded(
              child: Center(
                child: Text(
                  d,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  Widget _grid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 49,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final intensity = (index % 5) + 1;
        return Container(
          decoration: BoxDecoration(
            color: _colorForIntensity(intensity),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      },
    );
  }

  Color _colorForIntensity(int level) {
    switch (level) {
      case 1:
        return const Color(0xFFFFF7EC);
      case 2:
        return const Color(0xFFFFE8CC);
      case 3:
        return const Color(0xFFFFD7A6);
      case 4:
        return const Color(0xFFFFC480);
      default:
        return const Color(0xFFFFA44C);
    }
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
