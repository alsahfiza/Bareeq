import 'package:flutter/material.dart';

class ProductsFilters extends StatelessWidget {
  final String search;
  final String category;
  final String stock;
  final String status;
  final ValueChanged<String> onSearch;
  final VoidCallback onClearSearch;
  final ValueChanged<String?> onCategory;
  final ValueChanged<String?> onStock;
  final ValueChanged<String?> onStatus;

  const ProductsFilters({
    super.key,
    required this.search,
    required this.category,
    required this.stock,
    required this.status,
    required this.onSearch,
    required this.onClearSearch,
    required this.onCategory,
    required this.onStock,
    required this.onStatus,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        // Admin breakpoints
        int columns;
        if (width >= 1100) {
          columns = 4;
        } else if (width >= 700) {
          columns = 2;
        } else {
          columns = 1;
        }

        final itemWidth = (width - ((columns - 1) * 12)) / columns;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            _item(
              width: itemWidth,
              child: _searchField(),
            ),
            _item(
              width: itemWidth,
              child: _dropdown(
                value: category,
                items: const ['All', 'Wearables', 'Mobiles'],
                onChanged: onCategory,
              ),
            ),
            _item(
              width: itemWidth,
              child: _dropdown(
                value: stock,
                items: const ['All', 'In Stock', 'Low', 'Out'],
                onChanged: onStock,
              ),
            ),
            _item(
              width: itemWidth,
              child: _dropdown(
                value: status,
                items: const ['All', 'Active', 'Inactive'],
                onChanged: onStatus,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _item({required double width, required Widget child}) {
    return SizedBox(width: width, child: child);
  }

  Widget _searchField() {
    return TextField(
      onChanged: onSearch,
      controller: TextEditingController(text: search),
      decoration: InputDecoration(
        hintText: "Search product or SKU",
        prefixIcon: const Icon(Icons.search),
        suffixIcon: search.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClearSearch,
              )
            : null,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _dropdown({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}