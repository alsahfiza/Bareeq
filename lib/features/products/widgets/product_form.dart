import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import '../../../data/models/product_model.dart';
import 'barcode_input_field.dart';


class ProductForm extends StatefulWidget {
  final ProductModel? initial;
  final ValueChanged<ProductModel> onSubmit;
  final String submitLabel;

  const ProductForm({
    super.key,
    this.initial,
    required this.onSubmit,
    required this.submitLabel,
  });

  @override
  State<ProductForm> createState() => _ProductFormState();
}

class _ProductFormState extends State<ProductForm> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameCtrl;
  late final TextEditingController codeCtrl;
  late final TextEditingController barcodeCtrl;
  late final TextEditingController costCtrl;
  late final TextEditingController priceCtrl;
  late final TextEditingController qtyCtrl;
  late final TextEditingController descCtrl;

  String category = 'Beauty';

  @override
  void initState() {
    super.initState();
    final p = widget.initial;

    nameCtrl = TextEditingController(text: p?.name ?? '');
    codeCtrl = TextEditingController(text: p?.sku ?? '');
    barcodeCtrl = TextEditingController(text: p?.barcode ?? '');
    costCtrl =
        TextEditingController(text: p?.costPrice.toString() ?? '');
    priceCtrl =
        TextEditingController(text: p?.sellingPrice.toString() ?? '');
    qtyCtrl = TextEditingController(text: p?.quantity.toString() ?? '');
    descCtrl = TextEditingController(text: p?.description ?? '');
    category = p?.category ?? 'Beauty';
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    codeCtrl.dispose();
    barcodeCtrl.dispose();
    costCtrl.dispose();
    priceCtrl.dispose();
    qtyCtrl.dispose();
    descCtrl.dispose();
    super.dispose();
  }

  File? imageFile;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final file = await picker.pickImage(source: ImageSource.gallery);
    if (file != null) {
        setState(() {
            imageFile = File(file.path);
            });
    }
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final product = ProductModel(
      id: widget.initial?.id ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      name: nameCtrl.text.trim(),
      sku: codeCtrl.text.trim(),
      barcode: barcodeCtrl.text.trim(),
      category: category,
      brand: widget.initial?.brand ?? '',
      costPrice: double.parse(costCtrl.text),
      sellingPrice: double.parse(priceCtrl.text),
      quantity: int.parse(qtyCtrl.text),
      lowStock: widget.initial?.lowStock ?? 0,
      active: true,
      description: descCtrl.text.trim(),
    );

    widget.onSubmit(product);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          _row(
            _input('Name *', nameCtrl),
            _input('Code *', codeCtrl),
          ),
          const SizedBox(height: 16),

          _row(
            BarcodeInputField(controller: barcodeCtrl),
            _dropdown(),
          ),
          const SizedBox(height: 16),

          _row(
            _input('Cost *', costCtrl, isNumber: true),
            _input('Price *', priceCtrl, isNumber: true),
          ),
          const SizedBox(height: 16),

          _input('Quantity *', qtyCtrl, isNumber: true),
          const SizedBox(height: 16),

          TextFormField(
            controller: descCtrl,
            maxLines: 4,
            decoration: const InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),

          GestureDetector(
            onTap: _pickImage,
            child: Container(
                height: 140,
                decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(12),
                color: Colors.grey.shade50,
                ),
                child: imageFile == null
                    ? const Center(
                        child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                            Icon(Icons.cloud_upload_outlined),
                            SizedBox(height: 8),
                            Text('Upload image'),
                        ],
                        ),
                    )
                    : Image.file(imageFile!, fit: BoxFit.cover),
                    ),
            ),

          
          Align(
            alignment: Alignment.centerLeft,
            child: ElevatedButton(
              onPressed: _submit,
              child: Text(widget.submitLabel),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(Widget a, Widget b) {
    return Row(
      children: [
        Expanded(child: a),
        const SizedBox(width: 16),
        Expanded(child: b),
      ],
    );
  }

  Widget _input(
    String label,
    TextEditingController ctrl, {
    bool isNumber = false,
    }) {
    return TextFormField(
        controller: ctrl,
        keyboardType: isNumber ? TextInputType.number : TextInputType.text,
        validator: (v) {
        if (v == null || v.trim().isEmpty) {
            return '$label is required';
        }
        if (isNumber && double.tryParse(v) == null) {
            return '$label must be a number';
        }
        return null;
        },
        decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        ),
    );
    }


  Widget _dropdown() {
    return DropdownButtonFormField<String>(
      value: category,
      decoration: const InputDecoration(
        labelText: 'Category *',
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: 'Beauty', child: Text('Beauty')),
        DropdownMenuItem(value: 'Grocery', child: Text('Grocery')),
        DropdownMenuItem(
            value: 'Electronics', child: Text('Electronics')),
      ],
      onChanged: (v) => setState(() => category = v!),
    );
  }
}
