import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryPage extends StatefulWidget {
  final String categoryId;

  const CategoryPage({super.key, required this.categoryId});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  DocumentSnapshot? category;
  bool loadingCategory = true;

  List<DocumentSnapshot> products = [];
  bool loadingProducts = true;

  @override
  void initState() {
    super.initState();
    loadCategory();
    loadProducts();
  }

  // ---------------- LOAD CATEGORY DATA ----------------
  Future<void> loadCategory() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection("categories")
          .doc(widget.categoryId)
          .get();

      setState(() {
        category = snap;
        loadingCategory = false;
      });
    } catch (e) {
      debugPrint("Category load error: $e");
      setState(() => loadingCategory = false);
    }
  }

  // ---------------- LOAD PRODUCTS IN THIS CATEGORY ----------------
  Future<void> loadProducts() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection("products")
          .where("category_id", isEqualTo: widget.categoryId)
          .get();

      setState(() {
        products = snap.docs;
        loadingProducts = false;
      });
    } catch (e) {
      debugPrint("Product load error: $e");
      setState(() => loadingProducts = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

        appBar: AppBar(
          backgroundColor: Colors.blue.shade700,
          title: Text(
            loadingCategory
                ? "..."
                : category?["name_ar"] ?? "القسم",
          ),
        ),

        body: loadingCategory
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- CATEGORY BANNER ----------
        if (category?["image_url"] != null)
          Container(
            height: 160,
            width: double.infinity,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(category!["image_url"]),
                fit: BoxFit.cover,
              ),
            ),
          ),

        const SizedBox(height: 20),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            category?["name_ar"] ?? "",
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 20),

        Expanded(
          child: loadingProducts
              ? const Center(child: CircularProgressIndicator())
              : products.isEmpty
                  ? const Center(
                      child: Text(
                        "لا توجد منتجات في هذا القسم",
                        style: TextStyle(fontSize: 18),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: .70,
                      ),
                      itemCount: products.length,
                      itemBuilder: (context, i) {
                        var p = products[i];

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              "/product",
                              arguments: p.id,
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 4,
                                )
                              ],
                            ),
                            padding: const EdgeInsets.all(10),

                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // PRODUCT IMAGE
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      p["image_url"],
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),

                                const SizedBox(height: 8),

                                // PRODUCT NAME
                                Text(
                                  p["name_ar"] ?? "",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),

                                const SizedBox(height: 4),

                                // PRODUCT PRICE
                                Text(
                                  "${p["price"]} ر.س",
                                  style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
        ),
      ],
    );
  }
}
