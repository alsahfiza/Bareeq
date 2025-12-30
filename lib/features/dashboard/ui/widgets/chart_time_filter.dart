import 'package:flutter/material.dart';

enum ChartRange { day, week, month }

class ChartTimeFilter extends StatelessWidget {
  final ChartRange active;
  final ValueChanged<ChartRange> onChanged;

  const ChartTimeFilter({
    super.key,
    required this.active,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _item(context, ChartRange.day, '1D'),
        _item(context, ChartRange.week, '1W'),
        _item(context, ChartRange.month, '1M'),
      ],
    );
  }

  Widget _item(BuildContext context, ChartRange value, String label) {
    final selected = value == active;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        label: Text(label),
        selected: selected,
        onSelected: (_) => onChanged(value),
      ),
    );
  }
}
