import 'package:flutter/material.dart';
import '../../../../core/layout/admin_card.dart';

class TopProducts extends StatelessWidget {
  const TopProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      title: 'Top Selling Products',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isCompact = constraints.maxWidth < 420;

          return Column(
            children: [
              _row(
                rank: 1,
                name: 'Detergent 5L',
                sold: 342,
                revenue: 6840,
                compact: isCompact,
              ),
              _divider(),
              _row(
                rank: 2,
                name: 'Plastic Cups (100)',
                sold: 290,
                revenue: 4350,
                compact: isCompact,
              ),
              _divider(),
              _row(
                rank: 3,
                name: 'Trash Bags XL',
                sold: 214,
                revenue: 3210,
                compact: isCompact,
              ),
              _divider(),
              _row(
                rank: 4,
                name: 'Floor Cleaner',
                sold: 181,
                revenue: 2715,
                compact: isCompact,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _row({
    required int rank,
    required String name,
    required int sold,
    required double revenue,
    required bool compact,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _rankBadge(rank),
          const SizedBox(width: 12),

          Expanded(
            flex: 4,
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          if (!compact) ...[
            Expanded(
              flex: 2,
              child: Text(
                '$sold sold',
                textAlign: TextAlign.right,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            Expanded(
              flex: 2,
              child: Text(
                '\$${revenue.toStringAsFixed(0)}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ] else ...[
            Expanded(
              flex: 2,
              child: Text(
                '\$${revenue.toStringAsFixed(0)}',
                textAlign: TextAlign.right,
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _rankBadge(int rank) {
    Color color;
    switch (rank) {
      case 1:
        color = Colors.amber.shade700;
        break;
      case 2:
        color = Colors.grey.shade400;
        break;
      case 3:
        color = Colors.brown.shade400;
        break;
      default:
        color = Colors.blueGrey;
    }

    return Container(
      width: 28,
      height: 28,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        '#$rank',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      color: Colors.grey.shade300,
    );
  }
}