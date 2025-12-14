import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int totalProducts = 0;
  int totalOrders = 0;
  int pendingOrders = 0;
  int deliveredOrders = 0;
  double totalSales = 0.0;

  List<Map<String, dynamic>> latestOrders = [];
  List<Map<String, dynamic>> salesData = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadDashboardData();
  }

  // ----------------------------------------------------------
  //                  LOAD DASHBOARD DATA
  // ----------------------------------------------------------
  Future<void> loadDashboardData() async {
    try {
      final productsSnap =
          await FirebaseFirestore.instance.collection("products").get();

      final ordersSnap =
          await FirebaseFirestore.instance.collection("orders").orderBy("created_at", descending: true).get();

      int pending = 0;
      int delivered = 0;
      double sales = 0;

      for (var o in ordersSnap.docs) {
        final data = o.data();

        final status = data["status"] ?? "pending";
        final amount = double.tryParse(data["total"].toString()) ?? 0;

        if (status == "pending") pending++;
        if (status == "delivered") {
          delivered++;
          sales += amount;
        }
      }

      final latest = ordersSnap.docs.take(5).map((doc) {
        final d = doc.data();
        return {
          "id": doc.id,
          "customer": d["customer_name"] ?? "غير معروف",
          "total": d["total"] ?? 0,
          "status": d["status"] ?? "",
        };
      }).toList();

      setState(() {
        totalProducts = productsSnap.size;
        totalOrders = ordersSnap.size;
        pendingOrders = pending;
        deliveredOrders = delivered;
        totalSales = sales;
        latestOrders = latest;
        salesData = generateSalesChartData(ordersSnap.docs);
        loading = false;
      });
    } catch (e) {
      print("Error loading dashboard: $e");
      setState(() => loading = false);
    }
  }

  // ----------------------------------------------------------
  //               GENERATE SALES CHART DATA
  // ----------------------------------------------------------
  List<Map<String, dynamic>> generateSalesChartData(
      List<QueryDocumentSnapshot> orders) {
    Map<String, double> grouped = {};

    for (var o in orders) {
      final data = o.data() as Map<String, dynamic>;

      if (data["status"] != "delivered") continue;

      final Timestamp? ts = data["created_at"];
      if (ts == null) continue;

      final date = ts.toDate();
      final key = "${date.year}-${date.month}-${date.day}";
      final amount = double.tryParse(data["total"].toString()) ?? 0;

      grouped[key] = (grouped[key] ?? 0) + amount;
    }

    return grouped.entries.map((e) {
      return {
        "date": e.key,
        "value": e.value,
      };
    }).toList();
  }

  // ----------------------------------------------------------
  //                       UI BUILD
  // ----------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Dashboard Overview",
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          // METRICS CARDS
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            crossAxisSpacing: 20,
            mainAxisSpacing: 20,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              metricCard("Total Sales", "${totalSales.toStringAsFixed(2)} ر.س",
                  Icons.attach_money, Colors.green),
              metricCard("Total Orders", "$totalOrders",
                  Icons.shopping_cart, Colors.blue),
              metricCard("Pending Orders", "$pendingOrders",
                  Icons.pending_actions, Colors.orange),
              metricCard("Delivered Orders", "$deliveredOrders",
                  Icons.check_circle, Colors.teal),
            ],
          ),

          const SizedBox(height: 40),

          buildSalesChart(),

          const SizedBox(height: 40),

          const Text(
            "Latest Orders",
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 15),

          buildLatestOrdersTable(),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  //                        METRIC CARD
  // ----------------------------------------------------------
  Widget metricCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 36, color: color),
          const SizedBox(height: 20),
          Text(title, style: const TextStyle(fontSize: 15, color: Colors.grey)),
          const SizedBox(height: 8),
          Text(value,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  //                        SALES CHART
  // ----------------------------------------------------------
  Widget buildSalesChart() {
    if (salesData.isEmpty) {
      return const Text("No sales data available.");
    }

    final maxHeight = salesData.map((e) => e["value"] as double).reduce((a, b) => a > b ? a : b);

    return Container(
      padding: const EdgeInsets.all(20),
      height: 260,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Sales Chart (Delivered Orders)",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),

          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: salesData.map((point) {
                final double val = point["value"];
                final height = (val / maxHeight) * 150;

                return Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: height,
                        width: 14,
                        decoration: BoxDecoration(
                          color: Colors.blue.shade400,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(point["date"].toString().split("-").last,
                          style: const TextStyle(fontSize: 10)),
                    ],
                  ),
                );
              }).toList(),
            ),
          )
        ],
      ),
    );
  }

  // ----------------------------------------------------------
  //                    LATEST ORDERS TABLE
  // ----------------------------------------------------------
  Widget buildLatestOrdersTable() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: const [
              Expanded(child: Text("Order ID", style: headerStyle)),
              Expanded(child: Text("Customer", style: headerStyle)),
              Expanded(child: Text("Total", style: headerStyle)),
              Expanded(child: Text("Status", style: headerStyle)),
            ],
          ),
          const SizedBox(height: 10),

          ...latestOrders.map((o) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: [
                  Expanded(child: Text(o["id"])),
                  Expanded(child: Text(o["customer"])),
                  Expanded(child: Text("${o["total"]} ر.س")),
                  Expanded(child: Text(o["status"])),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

const headerStyle = TextStyle(
  fontWeight: FontWeight.bold,
  fontSize: 14,
);
