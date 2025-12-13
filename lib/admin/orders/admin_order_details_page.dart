import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminOrderDetailsPage extends StatefulWidget {
  final String orderId;

  const AdminOrderDetailsPage({super.key, required this.orderId});

  @override
  State<AdminOrderDetailsPage> createState() => _AdminOrderDetailsPageState();
}

class _AdminOrderDetailsPageState extends State<AdminOrderDetailsPage> {
  bool loading = true;
  Map<String, dynamic>? order;

  @override
  void initState() {
    super.initState();
    loadOrder();
  }

  Future<void> loadOrder() async {
    final snap = await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .get();

    setState(() {
      order = snap.data();
      loading = false;
    });
  }

  Future<void> updateStatus(String status) async {
    await FirebaseFirestore.instance
        .collection("orders")
        .doc(widget.orderId)
        .update({"status": status});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("تم تحديث حالة الطلب إلى: $status")),
    );

    loadOrder();
  }

  @override
  Widget build(BuildContext context) {
    if (loading || order == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final o = order!;
    final items = List<Map<String, dynamic>>.from(o["items"] ?? []);

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text("تفاصيل الطلب - ${widget.orderId}"),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// ============================
            /// ORDER SUMMARY CARD
            /// ============================
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("إجمالي المبلغ:", "${o['total']} ر.س"),
                    _infoRow("الحالة الحالية:", o["status"] ?? "غير محدد"),
                    _infoRow("التاريخ:", o["created_at"]?.toDate().toString() ?? "-"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// ============================
            /// CUSTOMER INFO CARD
            /// ============================
            const Text(
              "معلومات العميل",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _infoRow("الاسم:", o["customer_name"] ?? "-"),
                    _infoRow("رقم الجوال:", o["customer_phone"] ?? "-"),
                    _infoRow("العنوان:", o["customer_address"] ?? "-"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            /// ============================
            /// ORDER ITEMS LIST
            /// ============================
            const Text(
              "المنتجات",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            ...items.map((item) {
              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 15),
                child: ListTile(
                  title: Text(item["name_ar"]),
                  subtitle: Text("الكمية: ${item["qty"]}"),
                  trailing: Text("${item["price"]} ر.س"),
                ),
              );
            }),

            const SizedBox(height: 40),

            /// ============================
            /// STATUS UPDATE DROPDOWN
            /// ============================
            const Text(
              "تحديث حالة الطلب",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),

            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: DropdownButtonFormField<String>(
                  initialValue: o["status"] ?? "قيد المراجعة",
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(value: "قيد المراجعة", child: Text("قيد المراجعة")),
                    DropdownMenuItem(value: "قيد التجهيز", child: Text("قيد التجهيز")),
                    DropdownMenuItem(value: "تم الشحن", child: Text("تم الشحن")),
                    DropdownMenuItem(value: "تم التسليم", child: Text("تم التسليم")),
                    DropdownMenuItem(value: "ملغي", child: Text("ملغي")),
                  ],
                  onChanged: (value) {
                    if (value != null) updateStatus(value);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 18),
              overflow: TextOverflow.ellipsis,
            ),
          )
        ],
      ),
    );
  }
}
