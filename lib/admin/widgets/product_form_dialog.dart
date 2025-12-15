import 'package:flutter/material.dart';
import '../../shared/models/product_model.dart';
import '../../shared/services/product_service.dart';

class ProductFormDialog extends StatefulWidget {
  final ProductModel? product;
  const ProductFormDialog({super.key, this.product});

  @override
  State<ProductFormDialog> createState() => _ProductFormDialogState();
}

class _ProductFormDialogState extends State<ProductFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _service = ProductService();

  late TextEditingController name;
  late TextEditingController price;
  late TextEditingController stock;
  bool onSale = false;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.product?.name ?? '');
    price = TextEditingController(text: widget.product?.price.toString() ?? '');
    stock = TextEditingController(text: widget.product?.stock.toString() ?? '');
    onSale = widget.product?.onSale ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.product == null ? 'Add Product' : 'Edit Product'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(controller: name, decoration: const InputDecoration(labelText: 'Name')),
            TextFormField(controller: price, decoration: const InputDecoration(labelText: 'Price')),
            TextFormField(controller: stock, decoration: const InputDecoration(labelText: 'Stock')),
            SwitchListTile(
              title: const Text('On Sale'),
              value: onSale,
              onChanged: (v) => setState(() => onSale = v),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () async {
            final product = ProductModel(
              id: widget.product?.id ?? '',
              name: name.text,
              price: double.parse(price.text),
              discount: 0,
              onSale: onSale,
              stock: int.parse(stock.text),
              categoryId: 'default',
              isActive: true,
            );

            widget.product == null
                ? await _service.addProduct(product)
                : await _service.updateProduct(product);

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
