import 'package:flutter/material.dart';

class RecentTransactionsTable extends StatelessWidget {
  const RecentTransactionsTable({super.key});

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
          _table(),
        ],
      ),
    );
  }

  Widget _header() {
    return Row(
      children: const [
        Icon(Icons.table_chart, size: 18),
        SizedBox(width: 8),
        Text(
          'Recent Transactions',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Widget _table() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: DataTable(
        headingRowHeight: 42,
        dataRowHeight: 46,
        columnSpacing: 24,
        headingTextStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        columns: const [
          DataColumn(label: Text('Invoice')),
          DataColumn(label: Text('Customer')),
          DataColumn(label: Text('Date')),
          DataColumn(label: Text('Status')),
          DataColumn(
            numeric: true,
            label: Text('Amount'),
          ),
        ],
        rows: [
          _buildRow(
            invoice: '#INV-1001',
            customer: 'John Smith',
            date: '12 Jan 2025',
            status: TransactionStatus.paid,
            amount: '\$1,240',
          ),
          _buildRow(
            invoice: '#INV-1002',
            customer: 'Sarah Johnson',
            date: '12 Jan 2025',
            status: TransactionStatus.pending,
            amount: '\$980',
          ),
          _buildRow(
            invoice: '#INV-1003',
            customer: 'Michael Brown',
            date: '11 Jan 2025',
            status: TransactionStatus.cancelled,
            amount: '\$2,540',
          ),
          _buildRow(
            invoice: '#INV-1004',
            customer: 'Emily Davis',
            date: '11 Jan 2025',
            status: TransactionStatus.paid,
            amount: '\$760',
          ),
        ],
      ),
    );
  }

  DataRow _buildRow({
    required String invoice,
    required String customer,
    required String date,
    required TransactionStatus status,
    required String amount,
  }) {
    return DataRow(
      cells: [
        DataCell(Text(invoice)),
        DataCell(Text(customer)),
        DataCell(Text(date)),
        DataCell(_StatusChip(status: status)),
        DataCell(
          Text(
            amount,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  BoxDecoration _decoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: const [
        BoxShadow(
          color: Color(0x14000000),
          blurRadius: 14,
          offset: Offset(0, 8),
        ),
      ],
    );
  }
}

/* ---------------- STATUS ---------------- */

enum TransactionStatus { paid, pending, cancelled }

class _StatusChip extends StatelessWidget {
  final TransactionStatus status;

  const _StatusChip({required this.status});

  @override
  Widget build(BuildContext context) {
    late Color bg;
    late Color fg;
    late String label;

    switch (status) {
      case TransactionStatus.paid:
        bg = const Color(0xFFE6F6F1);
        fg = const Color(0xFF16A085);
        label = 'Paid';
        break;
      case TransactionStatus.pending:
        bg = const Color(0xFFFFF3E0);
        fg = const Color(0xFFFFA44C);
        label = 'Pending';
        break;
      case TransactionStatus.cancelled:
        bg = const Color(0xFFFFE5E0);
        fg = Colors.redAccent;
        label = 'Cancelled';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: fg,
        ),
      ),
    );
  }
}
