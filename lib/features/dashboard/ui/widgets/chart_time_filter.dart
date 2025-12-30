import 'package:flutter/material.dart';

class ChartTimeFilter extends StatelessWidget {
  const ChartTimeFilter({super.key});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      children: const [
        _FilterChip(label: 'Today', active: false),
        _FilterChip(label: 'Week', active: false),
        _FilterChip(label: 'Month', active: true),
        _FilterChip(label: 'Year', active: false),
      ],
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool active;

  const _FilterChip({
    required this.label,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: active ? const Color(0xFFFFA44C) : const Color(0xFFF4F6F8),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: active ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
