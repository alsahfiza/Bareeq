import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../providers/cart_provider.dart';

class CheckoutPage extends StatefulWidget {
  const CheckoutPage({super.key});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cityController = TextEditingController();
  final _addressController = TextEditingController();

  bool loading = false;

  Future<void> submitOrder() async {
    if (!_formKey.currentState!.validate()) return;

    final cart = Provider.of<CartProvider>(context, listen: false);

    if (cart.items.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("السلة فارغة")),
      );
      return;
    }

    setState(() => loading = true);

    // Create order object
    final orderData = {
      "customer_name": _nameController.text.trim(),
      "phone": _phoneController.text.trim(),
      "city": _cityController.text.trim(),
      "address": _addressController.text.trim(),
      "total": cart.total,
      "items": cart.items.map((e) {
        return {
          "id": e.id,
          "nameAr": e.nameAr,
          "imageUrl": e.imageUrl,
          "price": e.price,
          "quantity": e.quantity,
        };
      }).toList(),
      "created_at": FieldValue.serverTimestamp(),
      "status": "pending",
    };

    // Save order to Firestore
    final doc = await FirebaseFirestore.instance
        .collection("orders")
        .add(orderData);

    // Clear cart
    cart.clear();

    setState(() => loading = false);

    // Navigate to success page
    Navigator.pushReplacementNamed(
      context,
      "/order_success",
      arguments: doc.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue.shade700,
          title: const Text("إتمام الطلب"),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("المعلومات الشخصية",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),

                      // NAME
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: "الاسم الكامل",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "الرجاء إدخال الاسم" : null,
                      ),
                      const SizedBox(height: 15),

                      // PHONE
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: "رقم الجوال",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "الرجاء إدخال الجوال" : null,
                      ),
                      const SizedBox(height: 15),

                      // CITY
                      TextFormField(
                        controller: _cityController,
                        decoration: const InputDecoration(
                          labelText: "المدينة",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) =>
                            v == null || v.isEmpty ? "الرجاء إدخال المدينة" : null,
                      ),
                      const SizedBox(height: 15),

                      // ADDRESS
                      TextFormField(
                        controller: _addressController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: "العنوان (الحي – الشارع – التفاصيل)",
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => v == null || v.isEmpty
                            ? "الرجاء إدخال العنوان"
                            : null,
                      ),

                      const SizedBox(height: 30),

                      // SUMMARY
                      const Text("ملخص السلة",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),

                      ...cart.items.map((item) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.imageUrl,
                                  width: 70,
                                  height: 70,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  "${item.nameAr}\nالعدد: ${item.quantity}",
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ),
                              Text(
                                "${item.price * item.quantity} ر.س",
                                style: const TextStyle(
                                    fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        );
                      }),

                      const Divider(height: 40),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("الإجمالي:",
                              style: TextStyle(
                                  fontSize: 22, fontWeight: FontWeight.bold)),
                          Text("${cart.total.toStringAsFixed(2)} ر.س",
                              style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700)),
                        ],
                      ),

                      const SizedBox(height: 40),

                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green.shade700,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          onPressed: submitOrder,
                          child: const Text(
                            "تأكيد الطلب",
                            style: TextStyle(
                                fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
