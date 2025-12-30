import 'package:flutter/material.dart';

class LowStockProducts extends StatelessWidget {
  const LowStockProducts({super.key});

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
          _ProductRow(
            name: 'Apple iPhone 15',
            category: 'Electronics',
            quantity: '3 pcs',
          ),
          Divider(),
          _ProductRow(
            name: 'Logitech Mouse',
            category: 'Accessories',
            quantity: '5 pcs',
          ),
          Divider(),
          _ProductRow(
            name: 'HP Laptop',
            category: 'Computers',
            quantity: '2 pcs',
          ),
          Divider(),
          _ProductRow(
            name: 'Canon DSLR Camera',
            category: 'Photography',
            quantity: '4 pcs',
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
        Icon(Icons.warning_amber_rounded,
            size: 18, color: Color(0xFFFFA44C)),
        SizedBox(width: 8),
        Text(
          'Low Stock Products',
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/* ---------------- PRODUCT ROW ---------------- */

class _ProductRow extends StatelessWidget {
  final String name;
  final String category;
  final String quantity;

  const _ProductRow({
    required this.name,
    required this.category,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    final isCritical = int.tryParse(quantity.split(' ').first) != null &&
        int.parse(quantity.split(' ').first) <= 3;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _image(),
          const SizedBox(width: 12),
          Expanded(child: _info()),
          const SizedBox(width: 12),
          _badge(isCritical),
        ],
      ),
    );
  }

  Widget _image() {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F8),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Icon(Icons.inventory_2,
          size: 20, color: Colors.grey),
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
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          category,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _badge(bool critical) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: critical
            ? const Color(0xFFFFE5E0)
            : const Color(0xFFFFF3E0),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        quantity,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color:
              critical ? Colors.redAccent : const Color(0xFFFFA44C),
        ),
      ),
    );
  }
}
