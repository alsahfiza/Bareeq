import 'package:flutter/material.dart';

import '../../../data/models/product_model.dart';
import 'add_product_page.dart';
import 'view_product_page.dart';
import 'edit_product_page.dart';
import 'delete_confirmation_dialog.dart';

import '../widgets/products_header.dart';
import '../widgets/products_controls.dart';
import '../widgets/products_table_header.dart';
import '../widgets/product_row.dart';
import '../widgets/pagination_footer.dart';
import '../widgets/empty_state.dart';
import '../../../core/routing/app_routes.dart';


enum SortColumn { product, code, category, price, brand, cost, qty }

class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  // ================= DATA =================
  late List<ProductModel> _all;
  late List<ProductModel> _filtered;

  // ================= UI STATE =================
  final Set<String> _selectedIds = {};
  SortColumn _sortColumn = SortColumn.product;
  bool _ascending = true;

  // ================= PAGINATION =================
  int _rowsPerPage = 10;
  int _page = 1;
  String _search = '';

  // ================= SCROLL =================
  final ScrollController _horizontal = ScrollController();
  final ScrollController _vertical = ScrollController();

  static const double _tableWidth = 1300;

  @override
  void initState() {
    super.initState();
    _all = _mockProducts();
    _filtered = List.from(_all);
  }

  @override
  void dispose() {
    _horizontal.dispose();
    _vertical.dispose();
    super.dispose();
  }

  // ================= DERIVED =================
  int get _total => _filtered.length;

  int get _maxPage => (_total / _rowsPerPage).ceil().clamp(1, 999);

  List<ProductModel> get _paged {
    final start = (_page - 1) * _rowsPerPage;
    final end = (start + _rowsPerPage).clamp(0, _total);
    if (start >= _total) return [];
    return _filtered.sublist(start, end);
  }

  bool get _allSelected =>
      _paged.isNotEmpty &&
      _paged.every((p) => _selectedIds.contains(p.id));

  // ================= ACTIONS =================
  void _toggleSelectAll(bool value) {
    setState(() {
      if (value) {
        _selectedIds.addAll(_paged.map((e) => e.id));
      } else {
        _selectedIds.removeAll(_paged.map((e) => e.id));
      }
    });
  }

  void _toggleSelectOne(String id, bool value) {
    setState(() {
      value ? _selectedIds.add(id) : _selectedIds.remove(id);
    });
  }

  void _sort(SortColumn column) {
    setState(() {
      if (_sortColumn == column) {
        _ascending = !_ascending;
      } else {
        _sortColumn = column;
        _ascending = true;
      }

      _filtered.sort((a, b) {
        int r;
        switch (column) {
          case SortColumn.code:
            r = a.sku.compareTo(b.sku);
            break;
          case SortColumn.category:
            r = a.category.compareTo(b.category);
            break;
          case SortColumn.price:
            r = a.sellingPrice.compareTo(b.sellingPrice);
            break;
          case SortColumn.brand:
            r = a.brand.compareTo(b.brand);
            break;
          case SortColumn.cost:
            r = a.costPrice.compareTo(b.costPrice);
            break;
          case SortColumn.qty:
            r = a.quantity.compareTo(b.quantity);
            break;
          case SortColumn.product:
          default:
            r = a.name.compareTo(b.name);
        }
        return _ascending ? r : -r;
      });

      _page = 1;
    });
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // ===== PAGE HEADER =====
            ProductsHeader(
              onAdd: () async {
                final created = await Navigator.pushNamed<ProductModel>(
                  context,
                  AppRoutes.addProduct,
                );

                if (created != null) {
                  setState(() {
                    _all.insert(0, created);
                    _filtered = List.from(_all);
                    _page = 1;
                  });
                }
              },
            ),
            const SizedBox(height: 12),

            // ===== TABLE CARD =====
            Expanded(
              child: Center(
                child: SizedBox(
                  width: _tableWidth,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
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
                        // ===== CONTROLS (ALIGNED TO TABLE EDGES) =====
                        Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16, 16, 16, 8),
                          child: ProductsControls(
                            rowsPerPage: _rowsPerPage,
                            searchText: _search,
                            onRowsPerPageChanged: (v) {
                              setState(() {
                                _rowsPerPage = v;
                                _page = 1;
                              });
                            },
                            onSearchChanged: (q) {
                              setState(() {
                                _search = q;
                                final s = q.toLowerCase();
                                _filtered = _all.where((p) {
                                  return p.name
                                          .toLowerCase()
                                          .contains(s) ||
                                      p.sku
                                          .toLowerCase()
                                          .contains(s);
                                }).toList();
                                _page = 1;
                              });
                            },
                            onClearSearch: () {
                              setState(() {
                                _search = '';
                                _filtered = List.from(_all);
                                _page = 1;
                              });
                            },
                          ),
                        ),

                        const Divider(height: 1),

                        // ===== TABLE HEADER (HORIZONTAL SCROLL) =====
                        SingleChildScrollView(
                          controller: _horizontal,
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: _tableWidth,
                            child: ProductsTableHeader(
                              allSelected: _allSelected,
                              onSelectAll: _toggleSelectAll,
                              sortColumn: _sortColumn,
                              ascending: _ascending,
                              onSort: _sort,
                            ),
                          ),
                        ),

                        const Divider(height: 1),

                        // ===== ROWS =====
                        Expanded(
                          child: _paged.isEmpty
                              ? const EmptyState()
                              : Scrollbar(
                                  controller: _vertical,
                                  thumbVisibility: true,
                                  child: SingleChildScrollView(
                                    controller: _horizontal,
                                    scrollDirection:
                                        Axis.horizontal,
                                    child: SizedBox(
                                      width: _tableWidth,
                                      child: ListView.separated(
                                        controller: _vertical,
                                        itemCount: _paged.length,
                                        separatorBuilder:
                                            (_, __) => const Divider(height: 1),
                                        itemBuilder: (_, i) {
                                          final p = _paged[i];
                                          return ProductRow(
                                            product: p,
                                            selected:
                                                _selectedIds
                                                    .contains(p.id),
                                            onSelect:
                                                _toggleSelectOne,
                                            onView: () async {
                                              final updated = await Navigator.pushNamed<ProductModel>(
                                                context,
                                                AppRoutes.viewProduct,
                                                arguments: p,
                                              );
                                              if (updated != null) {
                                                setState(() {
                                                  final i = _all.indexWhere((e) => e.id == updated.id);
                                                  if (i != -1) _all[i] = updated;
                                                });
                                              }
                                            },
                                            onEdit: () async {
                                              final updated = await Navigator.pushNamed<ProductModel>(
                                                context,
                                                AppRoutes.editProduct,
                                                arguments: p,
                                              );
                                              if (updated != null) {
                                                setState(() {
                                                  final i = _all.indexWhere((e) => e.id == updated.id);
                                                  if (i != -1) _all[i] = updated;

                                                  final j = _filtered.indexWhere((e) => e.id == updated.id);
                                                  if (j != -1) _filtered[j] = updated;
                                                });
                                              }
                                            },
                                            onDelete: () async {
                                              final ok =
                                                  await showDialog<
                                                      bool>(
                                                context: context,
                                                builder: (_) =>
                                                    DeleteConfirmationDialog(itemName: p.name),
                                              );
                                              if (ok == true) {
                                                setState(() {
                                                  _all.removeWhere(
                                                      (e) => e.id == p.id);
                                                  _filtered
                                                      .removeWhere(
                                                          (e) => e.id == p.id);
                                                  _selectedIds
                                                      .remove(p.id);
                                                });
                                              }
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                                ),

                        // ===== PAGINATION =====
                        PaginationFooter(
                          from: (_page - 1) * _rowsPerPage + 1,
                          to: ((_page - 1) *
                                      _rowsPerPage +
                                  _paged.length)
                              .clamp(0, _total),
                          total: _total,
                          onPrev: _page > 1
                              ? () => setState(() => _page--)
                              : null,
                          onNext: _page < _maxPage
                              ? () => setState(() => _page++)
                              : null,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
    );
  }

  // ================= MOCK DATA =================
  List<ProductModel> _mockProducts() {
    return List.generate(
      50,
      (i) => ProductModel(
        id: '$i',
        name: 'Product $i',
        sku: 'SKU-$i',
        barcode: '97802013796$i',
        category: i.isEven ? 'Electronics' : 'Grocery',
        brand: 'Brand $i',
        costPrice: 40.0 + i,
        sellingPrice: 80.0 + i,
        quantity: 5 + i,
        lowStock: 5,
        active: true,
        description: 'Sample product',
      ),
    );
  }
}
