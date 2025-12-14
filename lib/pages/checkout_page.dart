import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../services/cart_service.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final nameCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final addressCtrl = TextEditingController();

  bool loading = false;

  Future<void> placeOrder() async {
    final cart = CartService.instance;
    if (cart.items.isEmpty) return;

    setState(() => loading = true);

    try {
      double total = cart.total;

      // BUILD ORDER
      final orderData = {
        "customer": {
          "name": nameCtrl.text.trim(),
          "phone": phoneCtrl.text.trim(),
          "address": addressCtrl.text.trim(),
        },
        "items": cart.items.map((i) => i.toMap()).toList(),
        "total": total,
        "status": "Pending",
        "created_at": DateTime.now(),
      };

      // SAVE ORDER TO FIRESTORE
      DocumentReference orderRef = await FirebaseFirestore.instance
          .collection("orders")
          .add(orderData);

      // UPDATE STOCK
      for (var item in cart.items) {
        FirebaseFirestore.instance
            .collection("products")
            .doc(item.id)
            .update({
          "stock": FieldValue.increment(-(item.quantity)),
          "sold_count": FieldValue.increment(item.quantity),
        });
      }

      // CLEAR CART
      cart.clear();

      if (mounted) {
        Navigator.pushReplacementNamed(
          context,
          "/order-success/${orderRef.id}",
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error placing order: $e")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("إتمام الطلب"),
          backgroundColor: Colors.blue.shade700,
        ),
        body: cart.items.isEmpty
            ? const Center(child: Text("السلة فارغة"))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    _input("الاسم", nameCtrl),
                    _input("رقم الجوال", phoneCtrl),
                    _input("العنوان التفصيلي", addressCtrl),

                    const SizedBox(height: 20),
                    _summary(cart),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: loading ? null : placeOrder,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          padding:
                              const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: loading
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text("تأكيد الطلب",
                                style: TextStyle(
                                    fontSize: 18, color: Colors.white)),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _input(String label, TextEditingController ctrl) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: ctrl,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );
  }

  Widget _summary(CartService cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4)
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text("الإجمالي:",
                  style: TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
              Text("${cart.total} ر.س",
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
