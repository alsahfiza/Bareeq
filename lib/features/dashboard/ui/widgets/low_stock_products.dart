import 'package:flutter/material.dart';
import '../../../../core/layout/admin_card.dart';

class LowStockProducts extends StatelessWidget {
  const LowStockProducts({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      title: 'Low Stock Products',
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
                stock: 6,
                threshold: 20,
              ),
              _row(
                compact: compact,
                name: 'Plastic Cups (100pcs)',
                sku: 'PLS-023',
                stock: 12,
                threshold: 50,
              ),
              _row(
                compact: compact,
                name: 'Floor Detergent 5L',
                sku: 'DET-010',
                stock: 3,
                threshold: 15,
              ),
              _row(
                compact: compact,
                name: 'Trash Bags XL',
                sku: 'TRS-045',
                stock: 8,
                threshold: 30,
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
        _cell('Stock', flex: 2, bold: true, alignRight: true),
        _cell('Status', flex: 2, bold: true),
      ],
    );
  }

  Widget _row({
    required bool compact,
    required String name,
    required String sku,
    required int stock,
    required int threshold,
  }) {
    final isCritical = stock <= threshold * 0.25;
    final isLow = stock <= threshold;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _cell(name, flex: 4, bold: true),
          if (!compact) _cell(sku, flex: 2, muted: true),
          _cell(
            stock.toString(),
            flex: 2,
            alignRight: true,
            bold: true,
          ),
          _statusCell(
            isCritical
                ? 'Critical'
                : isLow
                    ? 'Low'
                    : 'OK',
            flex: 2,
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

  Widget _statusCell(String status, {required int flex}) {
    Color bg;
    Color fg;

    switch (status) {
      case 'Critical':
        bg = Colors.red.shade100;
        fg = Colors.red.shade800;
        break;
      case 'Low':
        bg = Colors.orange.shade100;
        fg = Colors.orange.shade800;
        break;
      default:
        bg = Colors.green.shade100;
        fg = Colors.green.shade800;
    }

    return Expanded(
      flex: flex,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          status,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: fg,
          ),
        ),
      ),
    );
  }
}