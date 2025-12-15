import 'package:flutter/material.dart';
import '../../shared/models/banner_model.dart';
import '../../shared/models/category_model.dart';
import '../../shared/services/banner_service.dart';
import '../../shared/services/category_service.dart';
import 'products_by_category_page.dart';
import 'my_orders_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bannerService = BannerService();
    final categoryService = CategoryService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Bareeq Store'),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const MyOrdersPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        children: [
          /// BANNERS
          SizedBox(
            height: 160,
            child: StreamBuilder<List<BannerModel>>(
              stream: bannerService.getActiveBanners(),
              builder: (_, snapshot) {
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox();
                }

                final banners = snapshot.data!;

                return PageView.builder(
                  itemCount: banners.length,
                  itemBuilder: (_, i) {
                    final b = banners[i];
                    return GestureDetector(
                      onTap: () {
                        if (b.type == 'category') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductsByCategoryPage(
                                categoryId: b.targetId,
                              ),
                            ),
                          );
                        }
                      },
                      child: Image.network(
                        b.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                );
              },
            ),
          ),

          /// CATEGORIES
          StreamBuilder<List<CategoryModel>>(
            stream: categoryService.getCategories(activeOnly: true),
            builder: (_, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                    child: CircularProgressIndicator());
              }

              final categories = snapshot.data!;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemCount: categories.length,
                itemBuilder: (_, i) {
                  final c = categories[i];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              ProductsByCategoryPage(
                            categoryId: c.id,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      child: Center(
                        child: Text(
                          c.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
