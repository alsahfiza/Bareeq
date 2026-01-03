import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import 'add_product_page.dart';
import '../widgets/products_table.dart';


class ProductsPage extends StatefulWidget {
  const ProductsPage({super.key});

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final List<ProductModel> _allProducts = [
    ProductModel(
      id: '1',
      name: 'Apple Watch Series 9',
      sku: 'AW-00921',
      barcode: '978020137962',
      category: 'Wearables',
      brand: 'Apple',
      costPrice: 500,
      sellingPrice: 640,
      quantity: 12,
      lowStock: 5,
      active: true,
      description: 'Apple Watch Series 9',
    ),
    ProductModel(
      id: '2',
      name: 'iPhone 15 Pro',
      sku: 'IP-15P',
      barcode: '978020137963',
      category: 'Mobiles',
      brand: 'Apple',
      costPrice: 900,
      sellingPrice: 1200,
      quantity: 2,
      lowStock: 5,
      active: true,
      description: 'iPhone 15 Pro',
    ),
  ];

  String _search = '';
  String _category = 'All';
  String _stock = 'All';
  String _status = 'All';

  String _sortBy = 'name';
  bool _sortAsc = true;

  final Set<String> _selectedIds = {};

  int _page = 1;
  final int _pageSize = 5;

  final Map<String, bool> _visibleColumns = {
    'category': true,
    'price': true,
    'stock': true,
    'status': true,
  };

  @override
  Widget build(BuildContext context) {
    final filtered = _applyFilters();
    final paged = _paginate(filtered);

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ================= HEADER =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Products',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddProductPage(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.add),
                    label: const Text('Add Product'),
                  ),
                ],
              ),
            ),
          ),

          // ================= STICKY FILTERS =================
          SliverPersistentHeader(
            pinned: true,
            delegate: _FiltersDelegate(
              child: _FiltersBar(
                search: _search,
                category: _category,
                stock: _stock,
                status: _status,
                onSearch: (v) => setState(() {
                  _search = v;
                  _page = 1;
                }),
                onClearSearch: () => setState(() {
                  _search = '';
                  _page = 1;
                }),
                onCategory: (v) => setState(() {
                  _category = v!;
                  _page = 1;
                }),
                onStock: (v) => setState(() {
                  _stock = v!;
                  _page = 1;
                }),
                onStatus: (v) => setState(() {
                  _status = v!;
                  _page = 1;
                }),
              ),
            ),
          ),

          // ================= TABLE =================
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ProductsTable(
                products: paged,
                total: filtered.length,
                page: _page,
                pageSize: _pageSize,
                selectedIds: _selectedIds,
                visibleColumns: _visibleColumns,
                sortBy: _sortBy,
                sortAsc: _sortAsc,
                onSelectAll: (v) {
                  setState(() {
                    v
                        ? _selectedIds.addAll(paged.map((e) => e.id))
                        : _selectedIds.clear();
                  });
                },
                onToggleSelect: (id, v) {
                  setState(() {
                    v ? _selectedIds.add(id) : _selectedIds.remove(id);
                  });
                },
                onSort: (key) {
                  setState(() {
                    if (_sortBy == key) {
                      _sortAsc = !_sortAsc;
                    } else {
                      _sortBy = key;
                      _sortAsc = true;
                    }
                  });
                },
                onPrev: _page > 1 ? () => setState(() => _page--) : null,
                onNext: _page * _pageSize < filtered.length
                    ? () => setState(() => _page++)
                    : null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ================= LOGIC =================

  List<ProductModel> _applyFilters() {
    final list = _allProducts.where((p) {
      if (_search.isNotEmpty &&
          !p.name.toLowerCase().contains(_search.toLowerCase()) &&
          !p.sku.toLowerCase().contains(_search.toLowerCase())) {
        return false;
      }

      if (_category != 'All' && p.category != _category) return false;

      if (_stock != 'All') {
        if (_stock == 'Out' && p.quantity != 0) return false;
        if (_stock == 'Low' &&
            !(p.quantity > 0 && p.quantity <= p.lowStock)) return false;
        if (_stock == 'In Stock' && p.quantity <= p.lowStock) return false;
      }

      if (_status != 'All') {
        if (_status == 'Active' && !p.active) return false;
        if (_status == 'Inactive' && p.active) return false;
      }

      return true;
    }).toList();

    list.sort((a, b) {
      int r;
      switch (_sortBy) {
        case 'price':
          r = a.sellingPrice.compareTo(b.sellingPrice);
          break;
        case 'stock':
          r = a.quantity.compareTo(b.quantity);
          break;
        default:
          r = a.name.compareTo(b.name);
      }
      return _sortAsc ? r : -r;
    });

    return list;
  }

  List<ProductModel> _paginate(List<ProductModel> list) {
    final start = (_page - 1) * _pageSize;
    final end = start + _pageSize;
    if (start >= list.length) return [];
    return list.sublist(start, end > list.length ? list.length : end);
  }
}


// ============================================================================
// ============================= WIDGETS ======================================
// ============================================================================

class _FiltersDelegate extends SliverPersistentHeaderDelegate {
  final Widget child;

  _FiltersDelegate({required this.child});

  @override
  double get minExtent => 88;

  @override
  double get maxExtent => 88;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return child;
  }

  @override
  bool shouldRebuild(_) => false;
}

class _FiltersBar extends StatelessWidget {
  final String search, category, stock, status;
  final ValueChanged<String> onSearch;
  final VoidCallback onClearSearch;
  final ValueChanged<String?> onCategory, onStock, onStatus;

  const _FiltersBar({
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
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: LayoutBuilder(
        builder: (context, c) {
          final isDesktop = c.maxWidth >= 900;
          final isTablet = c.maxWidth >= 600;

          return Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              SizedBox(
                width: isDesktop ? 320 : c.maxWidth,
                child: _searchField(),
              ),
              SizedBox(
                width: isDesktop ? 180 : isTablet ? 240 : c.maxWidth,
                child: _dropdown(
                    category, ['All', 'Wearables', 'Mobiles'], onCategory),
              ),
              SizedBox(
                width: isDesktop ? 160 : isTablet ? 240 : c.maxWidth,
                child: _dropdown(
                    stock, ['All', 'In Stock', 'Low', 'Out'], onStock),
              ),
              SizedBox(
                width: isDesktop ? 160 : isTablet ? 240 : c.maxWidth,
                child: _dropdown(
                    status, ['All', 'Active', 'Inactive'], onStatus),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _searchField() {
    return TextField(
      onChanged: onSearch,
      controller: TextEditingController(text: search),
      decoration: InputDecoration(
        hintText: 'Search product or SKU',
        prefixIcon: const Icon(Icons.search),
        suffixIcon: search.isNotEmpty
            ? IconButton(
                icon: const Icon(Icons.clear),
                onPressed: onClearSearch,
              )
            : null,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _dropdown(
      String value, List<String> items, ValueChanged<String?> onChanged) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items:
          items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }
}

class _BulkBar extends StatelessWidget {
  final int count;
  final VoidCallback onClear, onDelete;

  const _BulkBar({required this.count, required this.onClear, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text('$count selected'),
          const Spacer(),
          TextButton(onPressed: onClear, child: const Text('Clear')),
          const SizedBox(width: 8),
          ElevatedButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete),
            label: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

class _ColumnVisibilityDialog extends StatelessWidget {
  final Map<String, bool> visible;
  final VoidCallback onChanged;

  const _ColumnVisibilityDialog({required this.visible, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Visible Columns'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: visible.keys.map((k) {
          return CheckboxListTile(
            title: Text(k[0].toUpperCase() + k.substring(1)),
            value: visible[k],
            onChanged: (v) {
              visible[k] = v!;
              onChanged();
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
