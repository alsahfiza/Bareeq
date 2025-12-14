import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminProductsPage extends StatefulWidget {
  const AdminProductsPage({super.key});

  @override
  State<AdminProductsPage> createState() => _AdminProductsPageState();
}

class _AdminProductsPageState extends State<AdminProductsPage> {
  final TextEditingController searchCtrl = TextEditingController();
  List<DocumentSnapshot> allProducts = [];
  List<DocumentSnapshot> filtered = [];

  int rowsPerPage = 10;
  int currentPage = 0;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadProducts();
  }

  Future<void> loadProducts() async {
    setState(() => loading = true);

    var snap = await FirebaseFirestore.instance
        .collection("products")
        .orderBy("created_at", descending: true)
        .get();

    allProducts = snap.docs;
    filtered = allProducts;

    setState(() => loading = false);
  }

  void searchProducts(String value) {
    value = value.toLowerCase();

    setState(() {
      filtered = allProducts.where((p) {
        final nameAr = p["name_ar"].toString().toLowerCase();
        final nameEn = p["name_en"].toString().toLowerCase();
        return nameAr.contains(value) || nameEn.contains(value);
      }).toList();

      currentPage = 0;
    });
  }

  List<DocumentSnapshot> get paginated {
    int start = currentPage * rowsPerPage;
    int end = start + rowsPerPage;

    if (start >= filtered.length) return [];
    if (end > filtered.length) end = filtered.length;

    return filtered.sublist(start, end);
  }

  void deleteProduct(String id) async {
    await FirebaseFirestore.instance.collection("products").doc(id).delete();
    loadProducts();
  }

  Future<String> getCategoryName(String id) async {
    var cat = await FirebaseFirestore.instance.collection("categories").doc(id).get();
    return cat.exists ? cat["name_ar"] : "—";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // HEADER
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("المنتجات", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),

            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, "/admin/products/add"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              ),
              child: const Text("إضافة منتج", style: TextStyle(color: Colors.white)),
            )
          ],
        ),

        const SizedBox(height: 20),

        // SEARCH BAR
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: TextField(
            controller: searchCtrl,
            onChanged: searchProducts,
            decoration: const InputDecoration(
              hintText: "ابحث عن منتج...",
              prefixIcon: Icon(Icons.search),
              border: InputBorder.none,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // MAIN TABLE
        Expanded(
          child: loading
              ? const Center(child: CircularProgressIndicator())
              : filtered.isEmpty
                  ? const Center(child: Text("لا يوجد منتجات"))
                  : buildTable(),
        ),

        buildPagination(),
      ],
    );
  }

  Widget buildTable() {
    return ListView(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: const [
              Expanded(flex: 2, child: Text("الصورة", style: _headerStyle)),
              Expanded(flex: 3, child: Text("الاسم (ع)", style: _headerStyle)),
              Expanded(flex: 3, child: Text("الاسم (En)", style: _headerStyle)),
              Expanded(flex: 2, child: Text("السعر", style: _headerStyle)),
              Expanded(flex: 2, child: Text("القسم", style: _headerStyle)),
              Expanded(flex: 2, child: Text("الإجراءات", style: _headerStyle)),
            ],
          ),
        ),
        const Divider(),

        ...paginated.map((p) => FutureBuilder<String>(
              future: getCategoryName(p["category_id"]),
              builder: (context, cat) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: Row(
                    children: [
                      // IMAGE
                      Expanded(
                        flex: 2,
                        child: Image.network(p["image_url"], height: 60),
                      ),

                      Expanded(flex: 3, child: Text(p["name_ar"])),
                      Expanded(flex: 3, child: Text(p["name_en"])),
                      Expanded(flex: 2, child: Text("${p["price"]} ر.س")),
                      Expanded(flex: 2, child: Text(cat.data ?? "...")),

                      // ACTIONS
                      Expanded(
                        flex: 2,
                        child: Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.blue),
                              onPressed: () {
                                Navigator.pushNamed(context, "/admin/products/edit/${p.id}");
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => confirmDelete(p.id),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              },
            )),
      ],
    );
  }

  Widget buildPagination() {
    int totalPages = (filtered.length / rowsPerPage).ceil();
    if (totalPages == 0) totalPages = 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("صفحة ${currentPage + 1} من $totalPages"),
        const SizedBox(width: 15),

        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: currentPage == 0 ? null : () => setState(() => currentPage--),
        ),

        IconButton(
          icon: const Icon(Icons.arrow_forward_ios),
          onPressed: currentPage + 1 >= totalPages ? null : () => setState(() => currentPage++),
        ),
      ],
    );
  }

  void confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text("حذف المنتج"),
        content: const Text("هل أنت متأكد من حذف هذا المنتج؟"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(c), child: const Text("إلغاء")),
          TextButton(
            child: const Text("حذف", style: TextStyle(color: Colors.red)),
            onPressed: () {
              deleteProduct(id);
              Navigator.pop(c);
            },
          ),
        ],
      ),
    );
  }
}

const _headerStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
