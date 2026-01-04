import 'package:flutter/material.dart';
import '../../../../data/models/product_model.dart';

class ProductRow extends StatelessWidget {
  final ProductModel product;
  final bool selected;
  final void Function(String id, bool value) onSelect;
  final VoidCallback onView;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const ProductRow({
    super.key,
    required this.product,
    required this.selected,
    required this.onSelect,
    required this.onView,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
      child: Row(
        children: [
          Checkbox(
            value: selected,
            onChanged: (v) => onSelect(product.id, v ?? false),
          ),
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(product.name,
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                Text(product.sku,
                    style:
                        const TextStyle(fontSize: 12, color: Colors.black54)),
              ],
            ),
          ),
          Expanded(flex: 2, child: Text(product.sku)),
          Expanded(flex: 2, child: Text(product.category)),
          Expanded(flex: 1, child: Text('\$${product.sellingPrice}')),
          Expanded(flex: 2, child: Text(product.brand)),
          Expanded(flex: 1, child: Text('\$${product.costPrice}')),
          Expanded(flex: 1, child: Text('${product.quantity}')),
          SizedBox(
            width: 120,
            child: Row(
              children: [
                _Action(icon: Icons.visibility, color: Colors.blue, onTap: onView),
                _Action(icon: Icons.edit, color: Colors.orange, onTap: onEdit),
                _Action(icon: Icons.delete, color: Colors.red, onTap: onDelete),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Action extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _Action({
    required this.icon,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withOpacity(.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
