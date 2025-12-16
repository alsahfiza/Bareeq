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

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _service = ProductService();
  final _name = TextEditingController();
  final _price = TextEditingController();
  final _stock = TextEditingController();
  final _discount = TextEditingController();

  bool _onSale = false;
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.product != null) {
      _name.text = widget.product!.name;
      _price.text = widget.product!.price.toString();
      _stock.text = widget.product!.stock.toString();
      _discount.text = widget.product!.discount.toString();
      _onSale = widget.product!.onSale;
      _isActive = widget.product!.isActive;
    } else {
      _discount.text = '0';
      _onSale = false;
      _isActive = true;
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
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: _price,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Price'),
            ),
            TextField(
              controller: _stock,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Stock'),
            ),
            TextField(
              controller: _discount,
              keyboardType: TextInputType.number,
              decoration:
                  const InputDecoration(labelText: 'Discount (%)'),
            ),
            const SizedBox(height: 12),
            SwitchListTile(
              title: const Text('On Sale'),
              value: _onSale,
              onChanged: (v) => setState(() => _onSale = v),
            ),
            SwitchListTile(
              title: const Text('Active'),
              value: _isActive,
              onChanged: (v) => setState(() => _isActive = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () async {
            final price = double.parse(_price.text);
            final discount = double.parse(_discount.text);

            if (widget.product == null) {
              await _service.addProduct(
                ProductModel(
                  id: '',
                  name: _name.text,
                  price: price,
                  stock: int.parse(_stock.text),
                  categoryId: '',
                  discount: discount,
                  onSale: _onSale,
                  isActive: _isActive,
                ),
              );
            } else {
              await _service.updateProduct(
                widget.product!.id,
                {
                  'name': _name.text,
                  'price': price,
                  'stock': int.parse(_stock.text),
                  'discount': discount,
                  'onSale': _onSale,
                  'isActive': _isActive,
                },
              );
            }

            if (context.mounted) {
              Navigator.pop(context);
            }
          },
        ),
      ],
    );
  }
}
