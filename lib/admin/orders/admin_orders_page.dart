import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../layout/admin_layout.dart';
import 'package:csv/csv.dart';

class AdminOrdersPage extends StatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  State<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends State<AdminOrdersPage> {
  List<DocumentSnapshot> allOrders = [];
  List<DocumentSnapshot> filteredOrders = [];
  final TextEditingController _searchCtrl = TextEditingController();

  int rowsPerPage = 10;
  int currentPage = 0;

  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  Future<void> loadOrders() async {
    var snap = await FirebaseFirestore.instance
        .collection("orders")
        .orderBy("created_at", descending: true)
        .get();

    setState(() {
      allOrders = snap.docs;
      filteredOrders = allOrders;
    });
  }

  void searchOrders(String text) {
    text = text.toLowerCase();
    setState(() {
      filteredOrders = allOrders.where((o) {
        final name = o["customer_name"].toString().toLowerCase();
        final phone = o["customer_phone"].toString().toLowerCase();
        return name.contains(text) || phone.contains(text);
      }).toList();
      currentPage = 0;
    });
  }

  List<DocumentSnapshot> get paginatedOrders {
    int start = currentPage * rowsPerPage;
    int end = start + rowsPerPage;

    if (start >= filteredOrders.length) return [];
    if (end > filteredOrders.length) end = filteredOrders.length;
    return filteredOrders.sublist(start, end);
  }

  String formatDate(dynamic ts) {
    if (ts is Timestamp) {
      final dt = ts.toDate();
      return "${dt.year}-${dt.month}-${dt.day} ${dt.hour}:${dt.minute}";
    }
    return "";
  }

  String statusText(String s) {
    switch (s) {
      case "pending":
        return "قيد المراجعة";
      case "processing":
        return "جارٍ التحضير";
      case "completed":
        return "مكتمل";
      case "cancelled":
        return "ملغي";
      default:
        return s;
    }
  }

  Color statusColor(String s) {
    switch (s) {
      case "pending":
        return Colors.orange;
      case "processing":
        return Colors.blue;
      case "completed":
        return Colors.green;
      case "cancelled":
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  Future<void> exportCSV() async {
    List<List<String>> rows = [];
    rows.add([
      "Order ID",
      "Customer Name",
      "Phone",
      "Total",
      "Status",
      "Created At"
    ]);

    for (var o in filteredOrders) {
      rows.add([
        o.id,
        o["customer_name"],
        o["customer_phone"],
        o["total"].toString(),
        o["status"],
        formatDate(o["created_at"]),
      ]);
    }

    final csv = ListToCsvConverter().convert(rows);
    debugPrint("CSV Export:");
    debugPrint(csv);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("CSV exported to console")),
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
            // HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Orders",
                    style: TextStyle(
                        fontSize: 26, fontWeight: FontWeight.bold)),

                ElevatedButton.icon(
                  onPressed: exportCSV,
                  icon: const Icon(Icons.table_chart),
                  label: const Text("Export CSV"),
                )
              ],
            ),

            const SizedBox(height: 20),

            // SEARCH BAR
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
                  hintText: "Search by name or phone",
                  border: InputBorder.none,
                ),
                onChanged: searchOrders,
              ),
            ),

            const SizedBox(height: 20),
            _tableHeader(),
            const Divider(),

            Expanded(
              child: paginatedOrders.isEmpty
                  ? const Center(child: Text("No orders found"))
                  : ListView(
                      children: paginatedOrders.map((o) {
                        return _orderRow(o);
                      }).toList(),
                    ),
            ),

            _paginationFooter()
          ],
        ),
      ),
    );
  }

  Widget _tableHeader() {
    return Row(
      children: const [
        Expanded(flex: 2, child: Text("Customer", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Phone", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Total", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Status", style: _headerStyle)),
        Expanded(flex: 2, child: Text("Date", style: _headerStyle)),
        Expanded(flex: 1, child: Text("Actions", style: _headerStyle)),
      ],
    );
  }

  Widget _orderRow(DocumentSnapshot o) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(o["customer_name"])),
          Expanded(flex: 2, child: Text(o["customer_phone"])),
          Expanded(flex: 2, child: Text("${o["total"]} ر.س")),

          // STATUS BADGE
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                  color: statusColor(o["status"]).withOpacity(.15),
                  borderRadius: BorderRadius.circular(30)),
              child: Text(
                statusText(o["status"]),
                style: TextStyle(
                  color: statusColor(o["status"]),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          Expanded(flex: 2, child: Text(formatDate(o["created_at"]))),

          Expanded(
            flex: 1,
            child: IconButton(
              icon: const Icon(Icons.chevron_right),
              onPressed: () {
                Navigator.pushNamed(context, "/admin/orders/${o.id}");
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _paginationFooter() {
    int totalPages = (filteredOrders.length / rowsPerPage).ceil();
    if (totalPages == 0) totalPages = 1;

    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text("Page ${currentPage + 1} of $totalPages"),
        IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed:
              currentPage == 0 ? null : () => setState(() => currentPage--),
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

const _headerStyle =
    TextStyle(fontSize: 16, fontWeight: FontWeight.bold);
