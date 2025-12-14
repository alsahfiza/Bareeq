import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  /// Fetch categories safely
  Future<List<QueryDocumentSnapshot>> fetchCategories() async {
    try {
      var snap =
          await FirebaseFirestore.instance.collection("categories").get();
      return snap.docs;
    } catch (e) {
      debugPrint("Category Load Error: $e");
      return [];
    }
  }

  /// Fetch featured products safely
  Future<List<QueryDocumentSnapshot>> fetchFeatured() async {
    try {
      var ref = FirebaseFirestore.instance.collection("products");

      // Try ordering by created_at
      QuerySnapshot snap;
      try {
        snap = await ref.orderBy("created_at", descending: true).limit(6).get();
      } catch (e) {
        // fallback if created_at missing
        debugPrint("created_at missing → fallback to no order");
        snap = await ref.limit(6).get();
      }

      return snap.docs;
    } catch (e) {
      debugPrint("Products Load Error: $e");
      return [];
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
          elevation: 0,
          title: const Text("بريق للمنظفات"),
          centerTitle: true,
        ),

        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // ------------------ HERO BANNER ------------------
              Container(
                height: 180,
                width: double.infinity,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(
                      "https://via.placeholder.com/1200x400?text=Bareeq+Stores",
                    ),
                    fit: BoxFit.cover,
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // ------------------ SEARCH BAR ------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "ابحث عن منتج…",
                    prefixIcon: const Icon(Icons.search),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  onSubmitted: (txt) {
                    Navigator.pushNamed(context, "/search", arguments: txt);
                  },
                ),
              ),

              const SizedBox(height: 25),

              // ------------------ CATEGORY TITLE ------------------
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "الأقسام",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 12),

              // ------------------ CATEGORIES ------------------
              SizedBox(
                height: 120,
                child: FutureBuilder(
                  future: fetchCategories(),
                  builder: (context, snap) {
                    if (!snap.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }

                    var cats = snap.data!;
                    if (cats.isEmpty) {
                      return const Center(child: Text("لا توجد أقسام متاحة"));
                    }

                    return ListView.separated(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      scrollDirection: Axis.horizontal,
                      itemCount: cats.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 16),
                      itemBuilder: (context, i) {
                        var c = cats[i];

                        return GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/category", arguments: c.id);
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 70,
                                height: 70,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(c["image_url"] ?? ""),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                c["name_ar"] ?? "بدون اسم",
                                style: const TextStyle(fontSize: 14),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                ),
              ),

              const SizedBox(height: 25),

              // ------------------ FEATURED PRODUCTS TITLE ------------------
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  "منتجات مميزة",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 12),

              // ------------------ FEATURED PRODUCTS GRID ------------------
              FutureBuilder(
                future: fetchFeatured(),
                builder: (context, snap) {
                  if (!snap.hasData) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }

                  var products = snap.data!;
                  if (products.isEmpty) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Text("لا توجد منتجات مميزة"),
                      ),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: products.length,
                    padding: const EdgeInsets.all(16),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: .70,
                    ),
                    itemBuilder: (context, i) {
                      var p = products[i];

                      return GestureDetector(
                        onTap: () =>
                            Navigator.pushNamed(context, "/product", arguments: p.id),

                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(color: Colors.black12, blurRadius: 4)
                            ],
                          ),
                          padding: const EdgeInsets.all(10),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
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

                              Text(
                                p["name_ar"] ?? "",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    const TextStyle(fontWeight: FontWeight.bold),
                              ),

                              const SizedBox(height: 4),

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
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
