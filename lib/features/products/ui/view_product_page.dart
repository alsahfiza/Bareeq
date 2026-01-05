import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import 'edit_product_page.dart';
import '../widgets/adjust_stock_dialog.dart';

class ViewProductPage extends StatefulWidget {
  final ProductModel product;

  const ViewProductPage({
    super.key,
    required this.product,
  });

  @override
  State<ViewProductPage> createState() => _ViewProductPageState();
}

class _ViewProductPageState extends State<ViewProductPage> {
  late ProductModel _product;

  @override
  void initState() {
    super.initState();
    _product = widget.product;
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // HEADER WITH BACK
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    // ✅ return updated product if changed
                    Navigator.pop(context, _product);
                  },
                ),
                const SizedBox(width: 8),
                const Text(
                  "View Product",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit"),
                  onPressed: () async {
                    final updated =
                        await Navigator.push<ProductModel>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditProductPage(product: _product),
                      ),
                    );

                    if (updated != null) {
                      setState(() {
                        _product = updated;
                      });
                    }
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            isWide
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(child: _infoCard()),
                      const SizedBox(width: 16),
                      Expanded(child: _stockCard(context)),
                    ],
                  )
                : Column(
                    children: [
                      _infoCard(),
                      const SizedBox(height: 16),
                      _stockCard(context),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _infoCard() {
    return _card(
      title: "Product Details",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Name", _product.name),
          _row("SKU", _product.sku),
          _row("Barcode", _product.barcode),
          _row("Category", _product.category),
          _row("Brand", _product.brand),
          _row("Price", "\$${_product.sellingPrice}"),
        ],
      ),
    );
  }

  Widget _stockCard(BuildContext context) {
    return _card(
      title: "Stock",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _row("Quantity", _product.quantity.toString()),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            icon: const Icon(Icons.sync),
            label: const Text("Adjust Stock"),
            onPressed: () async {
              final delta = await showDialog<int>(
                context: context,
                builder: (_) => AdjustStockDialog(
                  currentStock: _product.quantity,
                ),
              );
              if (delta != null) {
                final updated = _product.copyWith(
                  quantity: _product.quantity + delta,
                );
                Navigator.pop(context, updated);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  Widget _card({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
          const SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}