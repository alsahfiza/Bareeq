import 'package:flutter/material.dart';
import '../../shared/models/product_model.dart';
import '../../shared/services/product_service.dart';

class ProductFormDialog extends StatefulWidget {
  final ProductModel? product;

  const ProductFormDialog({super.key, this.product});

  @override
  State<ProductFormDialog> createState() =>
      _ProductFormDialogState();
}

class _ProductFormDialogState
    extends State<ProductFormDialog> {
  final ProductService _service = ProductService();

  // Core
  final TextEditingController _name = TextEditingController();
  final TextEditingController _description =
      TextEditingController();
  final TextEditingController _sku = TextEditingController();
  final TextEditingController _categoryId =
      TextEditingController();

  // Pricing
  final TextEditingController _price =
      TextEditingController();
  final TextEditingController _cost =
      TextEditingController();
  final TextEditingController _discount =
      TextEditingController();
  final TextEditingController _tax =
      TextEditingController();

  // Inventory
  final TextEditingController _stock =
      TextEditingController();
  final TextEditingController _lowStock =
      TextEditingController();
  final TextEditingController _weight =
      TextEditingController();

  // Status
  bool _onSale = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final p = widget.product;
    if (p != null) {
      _name.text = p.name;
      _description.text = p.description;
      _sku.text = p.sku;
      _categoryId.text = p.categoryId;
      _price.text = p.price.toString();
      _cost.text = p.cost.toString();
      _discount.text = p.discount.toString();
      _tax.text = p.taxPercent.toString();
      _stock.text = p.stock.toString();
      _lowStock.text = p.lowStockThreshold.toString();
      _weight.text = p.weight.toString();
      _onSale = p.onSale;
      _isActive = p.isActive;
    } else {
      _discount.text = '0';
      _tax.text = '0';
      _lowStock.text = '5';
      _weight.text = '0';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.product == null ? 'Add Product' : 'Edit Product',
      ),
      content: SingleChildScrollView(
        child: Column(
          children: [
            _field(_name, 'Name'),
            _field(_description, 'Description', maxLines: 3),
            _field(_sku, 'SKU'),
            _field(_categoryId, 'Category ID'),

            const Divider(),

            _field(_price, 'Price'),
            _field(_cost, 'Cost'),
            _field(_discount, 'Discount %'),
            _field(_tax, 'Tax %'),

            const Divider(),

            _field(_stock, 'Stock'),
            _field(_lowStock, 'Low Stock Alert'),
            _field(_weight, 'Weight (kg)'),

            const Divider(),

            SwitchListTile(
              title: const Text('On Sale'),
              value: _onSale,
              onChanged: (v) =>
                  setState(() => _onSale = v),
            ),
            SwitchListTile(
              title: const Text('Active'),
              value: _isActive,
              onChanged: (v) =>
                  setState(() => _isActive = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String label, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label),
    );
  }

  Future<void> _save() async {
    final String name = _name.text.trim();
    final String description = _description.text.trim();
    final String sku = _sku.text.trim();
    final String categoryId = _categoryId.text.trim();

    final double price = double.parse(_price.text);
    final double cost = double.parse(_cost.text);
    final double discount =
        double.parse(_discount.text);
    final double taxPercent =
        double.parse(_tax.text);

    final int stock = int.parse(_stock.text);
    final int lowStockThreshold =
        int.parse(_lowStock.text);
    final double weight =
        double.parse(_weight.text);

    if (widget.product == null) {
      await _service.add(
        ProductModel(
          id: '',
          name: name,
          description: description,
          sku: sku,
          categoryId: categoryId,
          price: price,
          cost: cost,
          discount: discount,
          taxPercent: taxPercent,
          stock: stock,
          lowStockThreshold: lowStockThreshold,
          weight: weight,
          onSale: _onSale,
          isActive: _isActive,
        ),
      );
    } else {
      await _service.update(
        widget.product!.id,
        {
          'name': name,
          'description': description,
          'sku': sku,
          'categoryId': categoryId,
          'price': price,
          'cost': cost,
          'discount': discount,
          'taxPercent': taxPercent,
          'stock': stock,
          'lowStockThreshold': lowStockThreshold,
          'weight': weight,
          'onSale': _onSale,
          'isActive': _isActive,
        },
      );
    }

    if (mounted) {
      Navigator.pop(context);
    }
  }
}
