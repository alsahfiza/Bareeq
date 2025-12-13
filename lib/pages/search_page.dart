import 'package:flutter/material.dart';
import '../services/firestore_service.dart';
import '../models/product_model.dart';
import '../widgets/product_card.dart';
import '../widgets/header.dart';
import '../widgets/whatsapp_button.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController ctrl = TextEditingController();
  List<ProductModel> results = [];
  bool loading = false;

  void search() async {
    setState(() => loading = true);
    results = await FirestoreService().searchProducts(ctrl.text);
    setState(() => loading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                TextField(
                  controller: ctrl,
                  decoration: InputDecoration(
                    hintText: "ابحث عن منتج",
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.search),
                      onPressed: search,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                loading
                    ? const Center(child: CircularProgressIndicator())
                    : Expanded(
                        child: GridView.count(
                          crossAxisCount:
                              MediaQuery.of(context).size.width > 800 ? 4 : 2,
                          children:
                              results.map((p) => ProductCard(product: p)).toList(),
                        ),
                      ),
              ],
            ),
          ),

          const WhatsAppButton(),
        ],
      ),
    );
  }
}
