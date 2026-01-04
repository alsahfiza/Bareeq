import 'package:flutter/material.dart';
import '../../../../data/models/product_model.dart';
import 'product_row.dart';

class ProductsTable extends StatelessWidget {
  final List<ProductModel> products;
  final int total;
  final int page;
  final int pageSize;
  final Set<String> selectedIds;
  final Map<String, bool> visibleColumns;
  final String sortBy;
  final bool sortAsc;
  final ValueChanged<bool> onSelectAll;
  final void Function(String, bool) onToggleSelect;
  final ValueChanged<String> onSort;
  final VoidCallback? onPrev;
  final VoidCallback? onNext;

  const ProductsTable({
    super.key,
    required this.products,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.selectedIds,
    required this.visibleColumns,
    required this.sortBy,
    required this.sortAsc,
    required this.onSelectAll,
    required this.onToggleSelect,
    required this.onSort,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    final maxPage = (total / pageSize).ceil().clamp(1, 999);

    return LayoutBuilder(
      builder: (context, constraints) {
        // Minimum width needed for table to look correct
        const minTableWidth = 900.0;
        final tableWidth =
            constraints.maxWidth < minTableWidth ? minTableWidth : constraints.maxWidth;

        // Column widths (shared with rows)
        const checkboxW = 48.0;
        const actionsW = 140.0;
        const smallColW = 90.0;
        const statusW = 110.0;

        final usedWidth = checkboxW +
            actionsW +
            (visibleColumns['price']! ? smallColW : 0) +
            (visibleColumns['stock']! ? smallColW : 0) +
            (visibleColumns['status']! ? statusW : 0) +
            (visibleColumns['category']! ? smallColW : 0);

        final productW = (tableWidth - usedWidth).clamp(220.0, 1000.0);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(color: Color(0x14000000), blurRadius: 12),
            ],
          ),
          child: Column(
            children: [
              // ================= HORIZONTAL SCROLL =================
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        _Header(
                          checkboxW: checkboxW,
                          productW: productW,
                          categoryW: smallColW,
                          priceW: smallColW,
                          stockW: smallColW,
                          statusW: statusW,
                          actionsW: actionsW,
                          visibleColumns: visibleColumns,
                          allSelected: products.isNotEmpty &&
                              selectedIds.length == products.length,
                          onSelectAll: onSelectAll,
                          sortBy: sortBy,
                          sortAsc: sortAsc,
                          onSort: onSort,
                        ),
                        const Divider(height: 24),
                        ...products.map(
                          (p) => ProductRow(
                            product: p,
                            selected: selectedIds.contains(p.id),
                            onSelect: (v) => onToggleSelect(p.id, v),
                            checkboxW: checkboxW,
                            productW: productW,
                            categoryW: smallColW,
                            priceW: smallColW,
                            stockW: smallColW,
                            statusW: statusW,
                            actionsW: actionsW,
                            visibleColumns: visibleColumns,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // ================= PAGINATION =================
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text('Page $page of $maxPage'),
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: onPrev,
                    ),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: onNext,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  final double checkboxW,
      productW,
      categoryW,
      priceW,
      stockW,
      statusW,
      actionsW;
  final Map<String, bool> visibleColumns;
  final bool allSelected;
  final ValueChanged<bool> onSelectAll;
  final String sortBy;
  final bool sortAsc;
  final ValueChanged<String> onSort;

  const _Header({
    required this.checkboxW,
    required this.productW,
    required this.categoryW,
    required this.priceW,
    required this.stockW,
    required this.statusW,
    required this.actionsW,
    required this.visibleColumns,
    required this.allSelected,
    required this.onSelectAll,
    required this.sortBy,
    required this.sortAsc,
    required this.onSort,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: checkboxW,
          child: Checkbox(
            value: allSelected,
            visualDensity: VisualDensity.compact,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            onChanged: (v) => onSelectAll(v!),
          ),
        ),
        _sortCell('Product', 'name', productW),
        if (visibleColumns['category']!)
          _cell('Category', categoryW),
        if (visibleColumns['price']!)
          _sortCell('Price', 'price', priceW),
        if (visibleColumns['stock']!)
          _sortCell('Stock', 'stock', stockW),
        if (visibleColumns['status']!)
          _cell('Status', statusW),
        SizedBox(width: actionsW, child: const Text('Actions')),
      ],
    );
  }

  Widget _cell(String text, double w) {
    return SizedBox(
      width: w,
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }

  Widget _sortCell(String text, String key, double w) {
    return SizedBox(
      width: w,
      child: InkWell(
        onTap: () => onSort(key),
        child: Row(
          children: [
            Text(text, style: const TextStyle(fontWeight: FontWeight.w600)),
            if (sortBy == key)
              Icon(
                sortAsc ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
              ),
          ],
        ),
      ),
    );
  }
}
