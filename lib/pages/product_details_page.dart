import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductDetailsPage extends StatefulWidget {
  final String id;
  const ProductDetailsPage({super.key, required this.id});

  @override
  State<ProductDetailsPage> createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {
  DocumentSnapshot? product;
  List<DocumentSnapshot> related = [];
  bool loading = true;
  int currentImage = 0;

  @override
  void initState() {
    super.initState();
    loadProduct();
  }

  Future<void> loadProduct() async {
    try {
      var snap = await FirebaseFirestore.instance
          .collection("products")
          .doc(widget.id)
          .get();

      product = snap;

      await loadRelatedProducts(product?["category_id"]);

      setState(() => loading = false);
    } catch (e) {
      debugPrint("Product error: $e");
      setState(() => loading = false);
    }
  }

  Future<void> loadRelatedProducts(String categoryId) async {
    var snap = await FirebaseFirestore.instance
        .collection("products")
        .where("category_id", isEqualTo: categoryId)
        .limit(6)
        .get();

    related = snap.docs.where((p) => p.id != widget.id).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,

        appBar: AppBar(
          backgroundColor: Colors.blue.shade700,
          title: const Text("تفاصيل المنتج"),
        ),

        body: loading
            ? const Center(child: CircularProgressIndicator())
            : _buildContent(),

        bottomNavigationBar: loading ? null : _bottomBar(),
      ),
    );
  }

  Widget _buildContent() {
    var p = product!.data() as Map<String, dynamic>;
    List images = p["images"] ?? [p["image_url"]]; // Support multiple images

    return ListView(
      children: [
        // ------------------ CAROUSEL -------------------
        SizedBox(
          height: 320,
          child: PageView.builder(
            itemCount: images.length,
            onPageChanged: (i) => setState(() => currentImage = i),
            itemBuilder: (_, i) {
              return Image.network(
                images[i],
                fit: BoxFit.cover,
                width: double.infinity,
              );
            },
          ),
        ),

        const SizedBox(height: 10),

        // DOTS INDICATOR
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            images.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: currentImage == i ? 14 : 7,
              height: 7,
              decoration: BoxDecoration(
                color: currentImage == i
                    ? Colors.blue.shade700
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ------------------ PRODUCT TEXT -------------------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            p["name_ar"],
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 10),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            "${p["price"]} ر.س",
            style: TextStyle(
              fontSize: 22,
              color: Colors.green.shade700,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 20),

        // ------------------ DESCRIPTION -------------------
        if (p["description"] != null &&
            p["description"].toString().trim().isNotEmpty)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              p["description"],
              style: const TextStyle(fontSize: 16, height: 1.6),
            ),
          ),

        const SizedBox(height: 20),

        // ------------------ RELATED PRODUCTS -------------------
        if (related.isNotEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Text(
              "منتجات مشابهة",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

        if (related.isNotEmpty) const SizedBox(height: 12),

        if (related.isNotEmpty)
          SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: related.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (_, i) {
                var r = related[i];
                var rp = r.data() as Map<String, dynamic>;
                return GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductDetailsPage(id: r.id),
                      ),
                    );
                  },
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(color: Colors.black12, blurRadius: 4)
                      ],
                    ),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(12),
                            topRight: Radius.circular(12),
                          ),
                          child: Image.network(
                            rp["image_url"],
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                rp["name_ar"],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                "${rp["price"]} ر.س",
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

        const SizedBox(height: 40),
      ],
    );
  }

  // ------------------ STICKY BOTTOM BAR -------------------
  Widget _bottomBar() {
    var p = product!.data() as Map<String, dynamic>;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              "${p["price"]} ر.س",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("تمت إضافة المنتج إلى السلة ✔")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green.shade700,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
            ),
            child: const Text(
              "أضف إلى السلة",
              style: TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}
