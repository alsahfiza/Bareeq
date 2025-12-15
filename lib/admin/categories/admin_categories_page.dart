import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'edit_category_page.dart';

class AdminCategoriesPage extends StatefulWidget {
  const AdminCategoriesPage({super.key});

  @override
  State<AdminCategoriesPage> createState() => _AdminCategoriesPageState();
}

class _AdminCategoriesPageState extends State<AdminCategoriesPage> {
  final TextEditingController _searchCtrl = TextEditingController();

  List<DocumentSnapshot> allCats = [];
  List<DocumentSnapshot> filteredCats = [];

  int rowsPerPage = 10;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadCategories();
  }

  Future<void> loadCategories() async {
    var snap = await FirebaseFirestore.instance.collection("categories").get();

    setState(() {
      allCats = snap.docs;
      filteredCats = allCats;
    });
  }

  void search(String value) {
    value = value.toLowerCase();

    setState(() {
      filteredCats = allCats.where((c) {
        final nameAr = c["name_ar"].toString().toLowerCase();
        return nameAr.contains(value);
      }).toList();

      currentPage = 0;
    });
  }

  List<DocumentSnapshot> get paginatedCats {
    int start = currentPage * rowsPerPage;
    int end = start + rowsPerPage;
    if (start >= filteredCats.length) return [];
    if (end > filteredCats.length) end = filteredCats.length;
    return filteredCats.sublist(start, end);
  }

  void deleteCategory(String id) async {
    await FirebaseFirestore.instance.collection("categories").doc(id).delete();
    loadCategories();
  }

  void confirmDelete(String id) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Category"),
        content: const Text("Are you sure you want to delete this category?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              deleteCategory(id);
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
    return Padding(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TITLE + ADD BUTTON
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("Categories",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade700,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, "/admin/categories/add");
                },
                child: const Text("Add Category", style: TextStyle(color: Colors.white)),
              ),
            ],
          ),

          const SizedBox(height: 25),

          // SEARCH BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4)
              ],
            ),
            child: TextField(
              controller: _searchCtrl,
              decoration: const InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search categories...",
                border: InputBorder.none,
              ),
              onChanged: search,
            ),
          ),

          const SizedBox(height: 20),

          // HEADER ROW
          Row(
            children: const [
              Expanded(flex: 2, child: Text("Image", style: _headerStyle)),
              Expanded(flex: 3, child: Text("Name (AR)", style: _headerStyle)),
              Expanded(flex: 2, child: Text("Actions", style: _headerStyle)),
            ],
          ),

          const Divider(),

          // TABLE CONTENT
          Expanded(
            child: filteredCats.isEmpty
                ? const Center(child: Text("No categories found"))
                : ListView(
                    children: paginatedCats.map((cat) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: Image.network(
                                cat["image_url"],
                                height: 60,
                                width: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: Text(cat["name_ar"]),
                            ),
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
                                              EditCategoryPage(categoryId: cat.id),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => confirmDelete(cat.id),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
          ),

          _paginationFooter(),
        ],
      ),
    );
  }

  Widget _paginationFooter() {
    int totalPages = (filteredCats.length / rowsPerPage).ceil();
    if (totalPages == 0) totalPages = 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Page ${currentPage + 1} of $totalPages"),
        ],
        );
  }
}

const _headerStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
