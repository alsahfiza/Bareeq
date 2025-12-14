import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../layout/admin_layout.dart';
import 'edit_product_page.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<DocumentSnapshot> _allProducts = [];
  List<DocumentSnapshot> _filteredProducts = [];
  List<DocumentSnapshot> _categories = [];

  String? selectedCategory;
  int rowsPerPage = 10;
  int currentPage = 0;

  bool sortAscending = true;
  String? sortColumn;

  @override
  void initState() {
    super.initState();
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    final productsSnap =
        await FirebaseFirestore.instance.collection("products").get();

    final categoriesSnap =
        await FirebaseFirestore.instance.collection("categories").get();

    setState(() {
      _allProducts = productsSnap.docs;
      _categories = categoriesSnap.docs;
      _filteredProducts = _allProducts;
    });
  }

  // -----------------------------
  // SEARCH
  // -----------------------------
  void searchProducts(String query) {
    query = query.toLowerCase();

    setState(() {
      _filteredProducts = _allProducts.where((p) {
        final nameAr = p["name_ar"].toString().toLowerCase();
        final nameEn = p["name_en"].toString().toLowerCase();

        return nameAr.contains(query) || nameEn.contains(query);
      }).toList();

      currentPage = 0;
    });
  }

  // -----------------------------
  // FILTER BY CATEGORY
  // -----------------------------
  void filterByCategory(String? categoryId) {
    setState(() {
      selectedCategory = categoryId;

      if (categoryId == null) {
        _filteredProducts = _allProducts;
      } else {
        _filteredProducts =
            _allProducts.where((p) => p["category_id"] == categoryId).toList();
      }

      currentPage = 0;
    });
  }

  // -----------------------------
  // SORTING LOGIC
  // -----------------------------
  void sortByColumn(String field) {
    setState(() {
      sortColumn = field;
      sortAscending = !sortAscending;

      _filteredProducts.sort((a, b) {
        final aVal = a[field];
        final bVal = b[field];

        if (aVal is num && bVal is num) {
          return sortAscending ? aVal.compareTo(bVal) : bVal.compareTo(aVal);
        }

        return sortAscending
            ? aVal.toString().compareTo(bVal.toString())
            : bVal.toString().compareTo(aVal.toString());
      });
    });
  }

  // -----------------------------
  // PAGINATION LOGIC
  // -----------------------------
  List<DocumentSnapshot> get paginatedProducts {
    int start = currentPage * rowsPerPage;
    int end = start + rowsPerPage;

    if (start >= _filteredProducts.length) return [];
    if (end > _filteredProducts.length) end = _filteredProducts.length;

    return _filteredProducts.sublist(start, end);
  }

  // -----------------------------
  // DELETE PRODUCT
  // -----------------------------
  void deleteProduct(String id) async {
    await FirebaseFirestore.instance.collection("products").doc(id).delete();
    loadInitialData();
  }

  Future<String> getCategoryName(String id) async {
    var cat = await FirebaseFirestore.instance
        .collection("categories")
        .doc(id)
        .get();

    return cat.exists ? cat["name_ar"] : "غير معروف";
  }

  // ================================================================
  // UI
  // ================================================================
  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          children: [
            headerSection(),
            const SizedBox(height: 20),
            searchAndFilter(),
            const SizedBox(height: 20),
            tableHeader(),
            const Divider(),
            Expanded(
              child: _filteredProducts.isEmpty
                  ? const Center(child: Text("لا توجد منتجات"))
                  : productList(),
            ),
            paginationFooter(),
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // HEADER + ADD PRODUCT BUTTON
  // -----------------------------
  Widget headerSection() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("Products",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
          onPressed: () => Navigator.pushNamed(context, "/admin/products/add"),
          child: const Text("Add Product",
              style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  // -----------------------------
  // SEARCH + CATEGORY FILTER
  // -----------------------------
  Widget searchAndFilter() {
    return Row(
      children: [
        // SEARCH
        Expanded(
          flex: 3,
          child: TextField(
            controller: _searchCtrl,
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search),
              hintText: "Search...",
              border: OutlineInputBorder(),
            ),
            onChanged: searchProducts,
          ),
        ),
        const SizedBox(width: 20),

        // CATEGORY DROPDOWN
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: selectedCategory,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              labelText: "Filter by Category",
            ),
            items: [
              const DropdownMenuItem(value: null, child: Text("All Categories")),
              ..._categories.map(
                (c) => DropdownMenuItem(
                  value: c.id,
                  child: Text(c["name_ar"]),
                ),
              ),
            ],
            onChanged: filterByCategory,
          ),
        )
      ],
    );
  }

  // -----------------------------
  // TABLE HEADER
  // -----------------------------
  Widget tableHeader() {
    return Row(
      children: [
        headerCell("Image"),
        sortableCell("Name (AR)", "name_ar"),
        sortableCell("Name (EN)", "name_en"),
        sortableCell("Price", "price"),
        headerCell("Category"),
        headerCell("Actions"),
      ],
    );
  }

  Widget headerCell(String title) {
    return Expanded(
      flex: title == "Image" ? 2 : 3,
      child: Text(title,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
    );
  }

  Widget sortableCell(String title, String field) {
    return Expanded(
      flex: 3,
      child: InkWell(
        onTap: () => sortByColumn(field),
        child: Row(
          children: [
            Text(title,
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Icon(
              sortColumn == field
                  ? (sortAscending
                      ? Icons.arrow_drop_up
                      : Icons.arrow_drop_down)
                  : Icons.swap_vert,
              size: 20,
            )
          ],
        ),
      ),
    );
  }

  // -----------------------------
  // PRODUCTS TABLE ROWS
  // -----------------------------
  Widget productList() {
    return ListView(
      children: paginatedProducts.map((p) {
        return FutureBuilder<String>(
          future: getCategoryName(p["category_id"]),
          builder: (context, snap) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  // IMAGE
                  Expanded(
                    flex: 2,
                    child: Image.network(p["image_url"],
                        height: 60, fit: BoxFit.cover),
                  ),

                  Expanded(flex: 3, child: Text(p["name_ar"])),
                  Expanded(flex: 3, child: Text(p["name_en"])),
                  Expanded(flex: 2, child: Text("${p["price"]} ر.س")),
                  Expanded(flex: 2, child: Text(snap.data ?? "...")),

                  // ACTIONS
                  Expanded(
                    flex: 2,
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) =>
                                    EditProductPage(productId: p.id),
                              ),
                            );
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => confirmDelete(p.id),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }

  // -----------------------------
  // DELETE CONFIRMATION
  // -----------------------------
  void confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Are you sure?"),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              deleteProduct(id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  // -----------------------------
  // PAGINATION FOOTER
  // -----------------------------
  Widget paginationFooter() {
    int totalPages = (_filteredProducts.length / rowsPerPage).ceil();
    if (totalPages == 0) totalPages = 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Page ${currentPage + 1} of $totalPages"),
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed:
              currentPage == 0 ? null : () => setState(() => currentPage--),
        ),
        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: (currentPage + 1) >= totalPages
              ? null
              : () => setState(() => currentPage++),
        ),
      ],
    );
  }
}
