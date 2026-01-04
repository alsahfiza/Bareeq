import 'package:flutter/material.dart';

class ProductsControls extends StatelessWidget {
  final int rowsPerPage;
  final String searchText;
  final ValueChanged<int> onRowsPerPageChanged;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onClearSearch;

  const ProductsControls({
    super.key,
    required this.rowsPerPage,
    required this.searchText,
    required this.onRowsPerPageChanged,
    required this.onSearchChanged,
    required this.onClearSearch,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: SizedBox(
        height: 40,
        child: Row(
          children: [
            // ================= LEFT: SHOW ENTRIES =================
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text("Show"),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 72,
                      height: 36,
                      child: DropdownButtonFormField<int>(
                        value: rowsPerPage,
                        isDense: true,
                        decoration: const InputDecoration(
                          contentPadding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(value: 10, child: Text("10")),
                          DropdownMenuItem(value: 25, child: Text("25")),
                          DropdownMenuItem(value: 50, child: Text("50")),
                        ],
                        onChanged: (v) {
                          if (v != null) onRowsPerPageChanged(v);
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text("entries"),
                  ],
                ),
              ),
            ),

            // ================= RIGHT: SEARCH =================
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: SizedBox(
                  width: 260,
                  height: 36,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: "Search products…",
                      prefixIcon:
                          const Icon(Icons.search, size: 18),
                      isDense: true,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      border: const OutlineInputBorder(),
                      suffixIcon: searchText.isNotEmpty
                          ? IconButton(
                              icon:
                                  const Icon(Icons.clear, size: 18),
                              onPressed: onClearSearch,
                            )
                          : null,
                    ),
                    onChanged: onSearchChanged,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}