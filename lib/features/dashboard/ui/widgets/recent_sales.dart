import 'package:flutter/material.dart';

class RecentSales extends StatelessWidget {
  const RecentSales({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _decoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          _Header(),
          SizedBox(height: 12),
          _SaleRow(
            name: 'John Smith',
            time: '2 min ago',
            amount: '\$1,240',
          ),
          Divider(),
          _SaleRow(
            name: 'Sarah Johnson',
            time: '10 min ago',
            amount: '\$980',
          ),
          Divider(),
          _SaleRow(
            name: 'Michael Brown',
            time: '25 min ago',
            amount: '\$2,540',
          ),
          Divider(),
          _SaleRow(
            name: 'Emily Davis',
            time: '1 hour ago',
            amount: '\$760',
          ),
        ],
      ),
    );
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

/* ---------------- HEADER ---------------- */

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Icon(Icons.receipt_long, size: 18),
        SizedBox(width: 8),
        Text(
          'Recent Sales',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/* ---------------- ROW ---------------- */

class _SaleRow extends StatelessWidget {
  final String name;
  final String time;
  final String amount;

  const _SaleRow({
    required this.name,
    required this.time,
    required this.amount,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _avatar(),
          const SizedBox(width: 12),
          Expanded(child: _info()),
          const SizedBox(width: 12),
          Text(
            amount,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }

  Widget _avatar() {
    return CircleAvatar(
      radius: 20,
      backgroundColor: const Color(0xFFF4F6F8),
      child: Text(
        name.isNotEmpty ? name[0] : '',
        style: const TextStyle(
          color: Colors.black87,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _info() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}
