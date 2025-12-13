import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int totalProducts = 0;
  int totalCategories = 0;
  int lowStockCount = 0;

  List<charts.Series<dynamic, String>> categoryChartData = [];

  @override
  void initState() {
    super.initState();
    loadDashboardData();
    loadCategoryChart();
  }

  Future<void> loadDashboardData() async {
    var productSnap = await FirebaseFirestore.instance.collection("products").get();
    var categorySnap = await FirebaseFirestore.instance.collection("categories").get();

    int lowStock = 0;
    for (var doc in productSnap.docs) {
      if ((doc["stock"] ?? 10) < 5) {
        lowStock++;
      }
    }

    setState(() {
      totalProducts = productSnap.size;
      totalCategories = categorySnap.size;
      lowStockCount = lowStock;
    });
  }

  Future<void> loadCategoryChart() async {
    var cats = await FirebaseFirestore.instance.collection("categories").get();
    var products = await FirebaseFirestore.instance.collection("products").get();

    Map<String, int> counts = {};

    for (var cat in cats.docs) {
      counts[cat["name_ar"]] = 0;
    }

    for (var p in products.docs) {
      String cid = p["category_id"];
      var cat = cats.docs.firstWhere((c) => c.id == cid, orElse: () => cats.docs.first);
      counts[cat["name_ar"]] = (counts[cat["name_ar"]] ?? 0) + 1;
    }

    var data = counts.entries
        .map((e) => _CategoryChartEntry(e.key, e.value))
        .toList();

    setState(() {
      categoryChartData = [
        charts.Series<_CategoryChartEntry, String>(
          id: "Categories",
          colorFn: (_, __) => charts.MaterialPalette.blue.shadeDefault,
          domainFn: (entry, _) => entry.category,
          measureFn: (entry, _) => entry.count,
          data: data,
          labelAccessorFn: (entry, _) => "${entry.category} (${entry.count})",
        )
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            "Dashboard Overview",
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),

          // ========================
          // TOP STATS CARDS
          // ========================
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statCard("Total Products", totalProducts.toString(), Icons.inventory),
              _statCard("Categories", totalCategories.toString(), Icons.category),
              _statCard("Low Stock", lowStockCount.toString(), Icons.warning_amber),
            ],
          ),

          const SizedBox(height: 40),

          // ========================
          // CATEGORY BREAKDOWN CHART
          // ========================
          Container(
            height: 350,
            padding: const EdgeInsets.all(20),
            decoration: _boxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Products by Category",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: charts.PieChart(
                    categoryChartData,
                    animate: true,
                    defaultRenderer: charts.ArcRendererConfig(
                      arcWidth: 70,
                      arcRendererDecorators: [
                        charts.ArcLabelDecorator(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 40),

          // ========================
          // BEST SELLING PRODUCTS (Static Placeholder)
          // ========================
          Container(
            padding: const EdgeInsets.all(20),
            decoration: _boxDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Top Selling Products (Placeholder)",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                _topSellingRow("سائل جلي", "230 مبيعة"),
                _topSellingRow("كلور مبيض", "180 مبيعة"),
                _topSellingRow("مناديل ورقية", "150 مبيعة"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ========================
  // REUSABLE WIDGETS
  // ========================

  Container _statCard(String title, String value, IconData icon) {
    return Container(
      width: 250,
      height: 130,
      padding: const EdgeInsets.all(20),
      decoration: _boxDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.blue, size: 30),
          const SizedBox(height: 10),
          Text(value, style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(fontSize: 16, color: Colors.black54)),
        ],
      ),
    );
  }

  BoxDecoration _boxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      boxShadow: const [
        BoxShadow(
          color: Colors.black12,
          blurRadius: 6,
          offset: Offset(0, 3),
        )
      ],
    );
  }

  Widget _topSellingRow(String name, String sales) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Expanded(child: Text(name, style: const TextStyle(fontSize: 16))),
          Text(sales, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }
}

// Data Model for Chart
class _CategoryChartEntry {
  final String category;
  final int count;

  _CategoryChartEntry(this.category, this.count);
}
