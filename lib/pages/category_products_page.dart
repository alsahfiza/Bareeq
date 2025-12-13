import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryProductsPage extends StatefulWidget {
  final String categoryId;

  const CategoryProductsPage({super.key, required this.categoryId});

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  bool loading = true;
  String categoryName = "";
  List<QueryDocumentSnapshot> products = [];

  @override
  void initState() {
    super.initState();
    loadCategoryAndProducts();
  }

  Future<void> loadCategoryAndProducts() async {
    // Load category name
    var catSnap = await FirebaseFirestore.instance
        .collection("categories")
        .doc(widget.categoryId)
        .get();

    if (catSnap.exists) {
      categoryName = catSnap["name_ar"];
    }

    // Load products for category
    var prodSnap = await FirebaseFirestore.instance
        .collection("products")
        .where("category_id", isEqualTo: widget.categoryId)
        .get();

    products = prodSnap.docs;

    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.blue.shade700,
          title: Text(categoryName),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : products.isEmpty
                ? const Center(
                    child: Text(
                      "لا توجد منتجات في هذا القسم",
                      style: TextStyle(fontSize: 18),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: .75,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
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
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // IMAGE
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

                              // NAME
                              Text(
                                p["name_ar"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),

                              const SizedBox(height: 4),

                              // PRICE
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
    );
  }
}
