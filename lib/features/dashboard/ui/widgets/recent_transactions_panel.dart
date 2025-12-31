import 'package:flutter/material.dart';

class RecentTransactionsPanel extends StatelessWidget {
  const RecentTransactionsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: 'Recent Transactions',
      trailing: const Text(
        'View All',
        style: TextStyle(fontSize: 11, color: Color(0xFF2563EB)),
      ),
      child: Column(
        children: const [
          _RowItem(
            invoice: '#INV-001',
            customer: 'Carlos Curran',
            date: '12 Jun 2024',
            amount: '\$1,200',
            status: 'Paid',
            isPaid: true,
          ),
          _Divider(),
          _RowItem(
            invoice: '#INV-002',
            customer: 'Stan Gaunter',
            date: '11 Jun 2024',
            amount: '\$820',
            status: 'Pending',
            isPaid: false,
          ),
          _Divider(),
          _RowItem(
            invoice: '#INV-003',
            customer: 'Mary Bronson',
            date: '10 Jun 2024',
            amount: '\$420',
            status: 'Paid',
            isPaid: true,
          ),
          _Divider(),
          _RowItem(
            invoice: '#INV-004',
            customer: 'Richard Wilson',
            date: '09 Jun 2024',
            amount: '\$1,450',
            status: 'Paid',
            isPaid: true,
          ),
        ],
      ),
    );
  }
}

/* ────────── ROW ────────── */

class _RowItem extends StatelessWidget {
  final String invoice;
  final String customer;
  final String date;
  final String amount;
  final String status;
  final bool isPaid;

  const _RowItem({
    required this.invoice,
    required this.customer,
    required this.date,
    required this.amount,
    required this.status,
    required this.isPaid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: Text(
              invoice,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            child: Text(
              customer,
              style: const TextStyle(fontSize: 12),
            ),
          ),
          SizedBox(
            width: 90,
            child: Text(
              date,
              style: const TextStyle(fontSize: 11, color: Colors.black45),
            ),
          ),
          SizedBox(
            width: 80,
            child: Text(
              amount,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 10),
          _StatusChip(label: status, isPaid: isPaid),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final bool isPaid;

  const _StatusChip({
    required this.label,
    required this.isPaid,
  });

  @override
  Widget build(BuildContext context) {
    final bg = isPaid ? const Color(0xFFE9F7F3) : const Color(0xFFFFF3E9);
    final fg = isPaid ? const Color(0xFF16A085) : const Color(0xFFFF8A00);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return const Divider(height: 1);
  }
}

/* ────────── CARD ────────── */

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  final Widget? trailing;

  const _Card({
    required this.title,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 360,
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              const Spacer(),
              if (trailing != null) trailing!,
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}
