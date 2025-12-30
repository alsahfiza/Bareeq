import 'package:flutter/material.dart';

class TopSellingProducts extends StatelessWidget {
  const TopSellingProducts({super.key});

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
            quantity: '120 pcs',
            price: '\$98,540',
          ),
          Divider(),
          _ProductRow(
            name: 'Samsung Galaxy S24',
            category: 'Electronics',
            quantity: '98 pcs',
            price: '\$76,220',
          ),
          Divider(),
          _ProductRow(
            name: 'Nike Air Max',
            category: 'Footwear',
            quantity: '86 pcs',
            price: '\$45,780',
          ),
          Divider(),
          _ProductRow(
            name: 'Sony Headphones',
            category: 'Accessories',
            quantity: '72 pcs',
            price: '\$32,910',
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
        Icon(Icons.local_fire_department, size: 18),
        SizedBox(width: 8),
        Text(
          'Top Selling Products',
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
  final String price;

  const _ProductRow({
    required this.name,
    required this.category,
    required this.quantity,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          _image(),
          const SizedBox(width: 12),
          Expanded(child: _info()),
          const SizedBox(width: 12),
          _stats(),
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
      child: const Icon(Icons.image, size: 20, color: Colors.grey),
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

  Widget _stats() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          quantity,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          price,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
