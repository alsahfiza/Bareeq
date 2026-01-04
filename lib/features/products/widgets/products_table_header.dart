import 'package:flutter/material.dart';
import '../ui/products_page.dart';

class ProductsTableHeader extends StatelessWidget {
  final bool allSelected;
  final ValueChanged<bool> onSelectAll;
  final SortColumn sortColumn;
  final bool ascending;
  final ValueChanged<SortColumn> onSort;

  const ProductsTableHeader({
    super.key,
    required this.allSelected,
    required this.onSelectAll,
    required this.sortColumn,
    required this.ascending,
    required this.onSort,
  });

  Widget _th(String label, SortColumn col) {
    return InkWell(
      onTap: () => onSort(col),
      child: Row(
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(width: 4),
          Icon(
            sortColumn == col
                ? (ascending
                    ? Icons.arrow_drop_up
                    : Icons.arrow_drop_down)
                : Icons.unfold_more,
            size: 16,
            color: Colors.black54,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF6F7FB),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        children: [
          Checkbox(
            value: allSelected,
            onChanged: (v) => onSelectAll(v ?? false),
          ),
          Expanded(flex: 3, child: _th('Product', SortColumn.product)),
          Expanded(flex: 2, child: _th('Code', SortColumn.code)),
          Expanded(flex: 2, child: _th('Category', SortColumn.category)),
          Expanded(flex: 1, child: _th('Price', SortColumn.price)),
          Expanded(flex: 2, child: _th('Brand', SortColumn.brand)),
          Expanded(flex: 1, child: _th('Cost', SortColumn.cost)),
          Expanded(flex: 1, child: _th('Qty', SortColumn.qty)),
          const SizedBox(width: 120, child: Text('Action')),
        ],
      ),
    );
  }
}
