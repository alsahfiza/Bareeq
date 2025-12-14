import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../layout/admin_layout.dart';

class AdminOrderDetailsPage extends StatefulWidget {
  final String orderId;
  const AdminOrderDetailsPage({super.key, required this.orderId});

  @override
  State<AdminOrderDetailsPage> createState() => _AdminOrderDetailsPageState();
}

class _AdminOrderDetailsPageState extends State<AdminOrderDetailsPage> {
  DocumentSnapshot? order;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadOrder();
  }

  Future<void> loadOrder() async {
    var snap = await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .get();

    setState(() {
      order = snap;
      loading = false;
    });
  }

  Future<void> updateStatus(String newStatus) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .update({"status": newStatus});

    loadOrder();
  }

  String formatDate(dynamic ts) {
    if (ts is Timestamp) {
      final dt = ts.toDate();
      return "${dt.year}-${dt.month}-${dt.day} ${dt.hour}:${dt.minute}";
    }
    return "";
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const AdminLayout(
        child: Center(child: CircularProgressIndicator()),
      );
    }

    var data = order!.data() as Map<String, dynamic>;
    List items = data["items"] ?? [];

    return AdminLayout(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Order #${widget.orderId}",
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            _section(
              "Customer Information",
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text("Name: ${data["customer_name"]}"),
                Text("Phone: ${data["customer_phone"]}"),
                Text("Address: ${data["address"]}"),
              ]),
            ),

            _section(
              "Order Summary",
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Total: ${data["total"]} ر.س",
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 6),
                  Text("Status: ${data["status"]}"),
                  Text("Created At: ${formatDate(data["created_at"])}"),
                ],
              ),
            ),

            _section(
              "Items",
              Column(
                children: items.map<Widget>((item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Row(
                      children: [
                        Expanded(flex: 3, child: Text(item["name"])),
                        Expanded(flex: 1, child: Text("x${item["qty"]}")),
                        Expanded(
                            flex: 2,
                            child: Text("${item["price"]} ر.س",
                                textAlign: TextAlign.right)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),
            _statusButtons(data["status"]),
          ],
        ),
      ),
    );
  }

  Widget _statusButtons(String s) {
    return Row(
      children: [
        _statusBtn("pending", "Pending", Colors.orange, s),
        const SizedBox(width: 10),
        _statusBtn("processing", "Processing", Colors.blue, s),
        const SizedBox(width: 10),
        _statusBtn("completed", "Completed", Colors.green, s),
        const SizedBox(width: 10),
        _statusBtn("cancelled", "Cancelled", Colors.red, s),
      ],
    );
  }

  Widget _statusBtn(String type, String label, Color color, String current) {
    return ElevatedButton(
      onPressed: current == type ? null : () => updateStatus(type),
      style: ElevatedButton.styleFrom(
        backgroundColor: current == type ? color.withOpacity(.4) : color,
      ),
      child: Text(label),
    );
  }

  Widget _section(String title, Widget child) {
    return Container(
      margin: const EdgeInsets.only(bottom: 25),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          child
        ],
      ),
    );
  }
}
