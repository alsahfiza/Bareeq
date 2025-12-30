import 'package:flutter/material.dart';
import '../../../../core/layout/admin_card.dart';

class TopSellingProducts extends StatelessWidget {
  const TopSellingProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      title: 'Top Selling Products',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;

          return Column(
            children: [
              _header(compact),
              const Divider(height: 16),

              _row(
                compact: compact,
                name: 'Glass Cleaner 1L',
                sku: 'CLN-001',
                sold: 342,
                revenue: 6840,
              ),
              _row(
                compact: compact,
                name: 'Plastic Cups (100pcs)',
                sku: 'PLS-023',
                sold: 298,
                revenue: 4470,
              ),
              _row(
                compact: compact,
                name: 'Floor Detergent 5L',
                sku: 'DET-010',
                sold: 221,
                revenue: 6630,
              ),
              _row(
                compact: compact,
                name: 'Trash Bags XL',
                sku: 'TRS-045',
                sold: 197,
                revenue: 2955,
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _header(bool compact) {
    return Row(
      children: [
        _cell('Product', flex: 4, bold: true),
        if (!compact) _cell('SKU', flex: 2, bold: true),
        _cell('Sold', flex: 2, bold: true, alignRight: true),
        _cell('Revenue', flex: 2, bold: true, alignRight: true),
      ],
    );
  }

  Widget _row({
    required bool compact,
    required String name,
    required String sku,
    required int sold,
    required double revenue,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _cell(name, flex: 4, bold: true),
          if (!compact) _cell(sku, flex: 2, muted: true),
          _cell(
            sold.toString(),
            flex: 2,
            alignRight: true,
            bold: true,
          ),
          _cell(
            _money(revenue),
            flex: 2,
            alignRight: true,
            bold: true,
          ),
        ],
      ),
    );
  }

  Widget _cell(
    String text, {
    required int flex,
    bool bold = false,
    bool muted = false,
    bool alignRight = false,
  }) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        textAlign: alignRight ? TextAlign.right : TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
          color: muted ? Colors.grey : null,
        ),
      ),
    );
  }

  String _money(double value) {
    return value.toStringAsFixed(2);
  }
}