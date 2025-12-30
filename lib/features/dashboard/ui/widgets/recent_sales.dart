import 'package:flutter/material.dart';
import '../../../../core/layout/admin_card.dart';

class RecentSalesTable extends StatelessWidget {
  const RecentSalesTable({super.key});

  @override
  Widget build(BuildContext context) {
    return AdminCard(
      title: 'Recent Sales',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 600;

          return Column(
            children: [
              _header(compact),
              const Divider(height: 16),

              _row(
                compact: compact,
                id: 'INV-10021',
                customer: 'Ahmed Ali',
                amount: 420.00,
                status: 'Paid',
                time: '10 min ago',
              ),
              _row(
                compact: compact,
                id: 'INV-10020',
                customer: 'Sara Khaled',
                amount: 315.50,
                status: 'Pending',
                time: '32 min ago',
              ),
              _row(
                compact: compact,
                id: 'INV-10019',
                customer: 'Mohammed Saeed',
                amount: 1280.00,
                status: 'Paid',
                time: '1 hr ago',
              ),
              _row(
                compact: compact,
                id: 'INV-10018',
                customer: 'Faisal Noor',
                amount: 210.75,
                status: 'Cancelled',
                time: '2 hr ago',
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
        _cell('Invoice', flex: 2, bold: true),
        if (!compact) _cell('Customer', flex: 3, bold: true),
        _cell('Amount', flex: 2, bold: true, alignRight: true),
        _cell('Status', flex: 2, bold: true),
        if (!compact) _cell('Time', flex: 2, bold: true),
      ],
    );
  }

  Widget _row({
    required bool compact,
    required String id,
    required String customer,
    required double amount,
    required String status,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          _cell(id, flex: 2),
          if (!compact) _cell(customer, flex: 3),
          _cell(
            '\$${amount.toStringAsFixed(2)}',
            flex: 2,
            alignRight: true,
            bold: true,
          ),
          _statusCell(status, flex: 2),
          if (!compact) _cell(time, flex: 2, muted: true),
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
      case 'Paid':
        bg = Colors.green.shade100;
        fg = Colors.green.shade800;
        break;
      case 'Pending':
        bg = Colors.orange.shade100;
        fg = Colors.orange.shade800;
        break;
      default:
        bg = Colors.red.shade100;
        fg = Colors.red.shade800;
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
