import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import '../layout/admin_layout.dart';
import 'edit_product_page.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<DocumentSnapshot> allProducts = [];
  List<DocumentSnapshot> filteredProducts = [];

  int rowsPerPage = 10;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    var snap = await FirebaseFirestore.instance.collection("products").get();

    setState(() {
      allProducts = snap.docs;
      filteredProducts = allProducts;
    });
  }

  void search(String value) {
    value = value.toLowerCase();

    setState(() {
      filteredProducts = allProducts.where((p) {
        final nameAr = p["name_ar"].toString().toLowerCase();
        return nameAr.contains(value);
      }).toList();
      currentPage = 0;
    });
  }

  List<DocumentSnapshot> get paginatedProducts {
    int start = currentPage * rowsPerPage;
    int end = start + rowsPerPage;

    if (start >= filteredProducts.length) return [];
    if (end > filteredProducts.length) end = filteredProducts.length;

    return filteredProducts.sublist(start, end);
  }

  Future<String> getCategoryName(String id) async {
    var cat = await FirebaseFirestore.instance.collection("categories").doc(id).get();
    return cat.exists ? cat["name_ar"] : "—";
  }

  Future<void> deleteProduct(String id) async {
    final doc = FirebaseFirestore.instance.collection("products").doc(id);
    final snap = await doc.get();

    if (snap.exists && snap["images"] != null) {
      List images = snap["images"];
      for (var url in images) {
        try {
          await FirebaseStorage.instance.refFromURL(url).delete();
        } catch (_) {}
      }
    }

    await doc.delete();
    loadProducts();
  }

  void _confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Product"),
        content: const Text("Are you sure you want to delete this product? This action cannot be undone."),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              deleteProduct(id);
              Navigator.pop(context);
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Products",
                    style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, "/admin/products/add");
                  },
                  child: const Text("Add Product", style: TextStyle(color: Colors.white)),
                )
              ],
            ),

            const SizedBox(height: 25),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
              ),
              child: TextField(
                controller: _searchCtrl,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.search),
                  hintText: "Search products...",
                  border: InputBorder.none,
                ),
                onChanged: search,
              ),
            ),

            const SizedBox(height: 20),

            _tableHeader(),
            const Divider(),

            Expanded(
              child: filteredProducts.isEmpty
                  ? const Center(child: Text("No products found"))
                  : ListView(
                      children: paginatedProducts.map((p) {
                        return FutureBuilder<String>(
                          future: getCategoryName(p["category_id"]),
                          builder: (_, snap) {
                            return _productRow(
                              p,
                              categoryName: snap.data ?? "...",
                            );
                          },
                        );
                      }).toList(),
                    ),
            ),

            const SizedBox(height: 10),

            _paginationFooter(),
          ],
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Row(
      children: const [
        Expanded(flex: 2, child: Text("Image", style: _headerStyle)),
        Expanded(flex: 3, child: Text("Name (AR)", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Price", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Category", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Actions", style: _headerStyle)),
      ],
    );
  }

  Widget _productRow(DocumentSnapshot p, {required String categoryName}) {
    final images = p["images"] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Image.network(
              images.isNotEmpty ? images[0] : "https://via.placeholder.com/100",
              height: 60,
              width: 60,
              fit: BoxFit.cover,
            ),
          ),

          Expanded(flex: 3, child: Text(p["name_ar"])),
          Expanded(flex: 2, child: Text("${p["price"]} ر.س")),
          Expanded(flex: 2, child: Text(categoryName)),

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
                        builder: (_) => EditProductPage(productId: p.id),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _confirmDelete(p.id),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paginationFooter() {
    int totalPages = (filteredProducts.length / rowsPerPage).ceil();
    if (totalPages == 0) totalPages = 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Page ${currentPage + 1} of $totalPages"),
        const SizedBox(width: 20),
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: currentPage == 0 ? null : () => setState(() => currentPage--),
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

const _headerStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
);
