import 'package:flutter/material.dart';

class PaginationFooter extends StatelessWidget {
  final int from;
  final int to;
  final int total;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const PaginationFooter({
    super.key,
    required this.from,
    required this.to,
    required this.total,
    this.onPrev,
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('Showing $from to $to of $total entries'),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.chevron_left),
                onPressed: onPrev,
                color: onPrev == null ? Colors.grey : null,
              ),
              IconButton(
                icon: const Icon(Icons.chevron_right),
                onPressed: onNext,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
