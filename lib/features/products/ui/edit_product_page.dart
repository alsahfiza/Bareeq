import 'package:flutter/material.dart';
import '../../../data/models/product_model.dart';
import 'barcode_input_field.dart';

class EditProductPage extends StatefulWidget {
  final ProductModel product;

  const EditProductPage({
    super.key,
    required this.product,
  });

  @override
  State<EditProductPage> createState() => _EditProductPageState();
}

class _EditProductPageState extends State<EditProductPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameController;
  late final TextEditingController skuController;
  late final TextEditingController barcodeController;
  late final TextEditingController brandController;
  late final TextEditingController costController;
  late final TextEditingController priceController;
  late final TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.product.name);
    skuController = TextEditingController(text: widget.product.sku);
    barcodeController = TextEditingController(text: widget.product.barcode);
    brandController = TextEditingController(text: widget.product.brand);
    costController =
        TextEditingController(text: widget.product.costPrice.toString());
    priceController =
        TextEditingController(text: widget.product.sellingPrice.toString());
    descriptionController =
        TextEditingController(text: widget.product.description);
  }

  @override
  void dispose() {
    nameController.dispose();
    skuController.dispose();
    barcodeController.dispose();
    brandController.dispose();
    costController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 1000;

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER WITH BACK
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    "Edit Product",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              isWide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _leftColumn()),
                        const SizedBox(width: 16),
                        Expanded(child: _rightColumn()),
                      ],
                    )
                  : Column(
                      children: [
                        _leftColumn(),
                        const SizedBox(height: 16),
                        _rightColumn(),
                      ],
                    ),

              const SizedBox(height: 24),

              // SAVE
              Align(
                alignment: Alignment.centerRight,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // save later
                      Navigator.pop(context);
                    }
                  },
                  child: const Text("Save Changes"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _leftColumn() {
    return Column(
      children: [
        _card(
          title: "Product Information",
          child: Column(
            children: [
              _input(
                controller: nameController,
                label: "Product Name",
                required: true,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _input(
                      controller: skuController,
                      label: "SKU",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: BarcodeInputField(
                      controller: barcodeController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _input(
                controller: brandController,
                label: "Brand",
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        _card(
          title: "Description",
          child: _input(
            controller: descriptionController,
            label: "Description",
            maxLines: 4,
          ),
        ),
      ],
    );
  }

  Widget _rightColumn() {
    return _card(
      title: "Pricing",
      child: Column(
        children: [
          _input(
            controller: costController,
            label: "Cost Price",
            isNumber: true,
          ),
          const SizedBox(height: 12),
          _input(
            controller: priceController,
            label: "Selling Price",
            isNumber: true,
            required: true,
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

  Widget _input({
    required TextEditingController controller,
    required String label,
    bool isNumber = false,
    bool required = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      validator: required
          ? (v) => v == null || v.isEmpty ? "$label is required" : null
          : null,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}