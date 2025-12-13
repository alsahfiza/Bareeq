import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminOrdersPage extends StatelessWidget {
  const AdminOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade700,
          title: const Text("إدارة الطلبات"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("orders")
              .orderBy("created_at", descending: true)
              .snapshots(),
          builder: (context, snap) {
            if (!snap.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            final orders = snap.data!.docs;

            if (orders.isEmpty) {
              return const Center(child: Text("لا توجد طلبات"));
            }

            return ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, i) {
                final order = orders[i];
                final data = order.data() as Map<String, dynamic>;
                final items = data["items"] as List;

                return Card(
                  margin: const EdgeInsets.all(12),
                  child: ExpansionTile(
                    title: Text(
                      "طلب #${order.id}",
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("الاسم: ${data["customer_name"]}"),
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("الجوال: ${data["phone"]}"),
                            Text("المدينة: ${data["city"]}"),
                            Text("العنوان: ${data["address"]}"),
                            const SizedBox(height: 8),
                            const Text("المنتجات:",
                                style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8),

                            ...items.map((item) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${item["nameAr"]} x${item["quantity"]}"),
                                    Text("${item["price"] * item["quantity"]} ر.س"),
                                  ],
                                ),
                              );
                            }),

                            const Divider(),

                            Text(
                              "الإجمالي: ${data["total"]} ر.س",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.green.shade700,
                              ),
                            ),

                            const SizedBox(height: 12),

                            // Order Status Controls
                            Row(
                              children: [
                                const Text("الحالة: ",
                                    style: TextStyle(fontSize: 16)),
                                DropdownButton<String>(
                                  value: data["status"],
                                  items: const [
                                    DropdownMenuItem(
                                      value: "pending",
                                      child: Text("قيد الانتظار"),
                                    ),
                                    DropdownMenuItem(
                                      value: "delivered",
                                      child: Text("تم التسليم"),
                                    ),
                                    DropdownMenuItem(
                                      value: "canceled",
                                      child: Text("ملغي"),
                                    ),
                                  ],
                                  onChanged: (value) {
                                    FirebaseFirestore.instance
                                        .collection("orders")
                                        .doc(order.id)
                                        .update({"status": value});
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
