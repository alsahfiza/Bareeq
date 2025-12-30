import 'package:flutter/material.dart';

class InventoryAdjustPage extends StatefulWidget {
  final String productName;
  final String productId;
  final int currentStock;

  const InventoryAdjustPage({
    super.key,
    required this.productName,
    required this.productId,
    this.currentStock = 0,
  });

  @override
  State<InventoryAdjustPage> createState() => _InventoryAdjustPageState();
}

class _InventoryAdjustPageState extends State<InventoryAdjustPage> {
  final _formKey = GlobalKey<FormState>();

  final _quantityController = TextEditingController();
  final _reasonController = TextEditingController();

  bool _isIncrease = true;

  @override
  void dispose() {
    _quantityController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Adjust Inventory',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),

                _infoRow('Product', widget.productName),
                _infoRow('Current Stock', widget.currentStock.toString()),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Increase'),
                        value: true,
                        groupValue: _isIncrease,
                        onChanged: (v) =>
                            setState(() => _isIncrease = true),
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: const Text('Decrease'),
                        value: false,
                        groupValue: _isIncrease,
                        onChanged: (v) =>
                            setState(() => _isIncrease = false),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                TextFormField(
                  controller: _quantityController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantity',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) {
                    final q = int.tryParse(v ?? '');
                    if (q == null || q <= 0) return 'Invalid quantity';
                    if (!_isIncrease && q > widget.currentStock) {
                      return 'Cannot reduce below zero';
                    }
                    return null;
                  },
                ),

                const SizedBox(height: 16),

                TextFormField(
                  controller: _reasonController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Reason / Note',
                    border: OutlineInputBorder(),
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),

                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: _submit,
                      child: const Text('Apply'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final quantity = int.parse(_quantityController.text);
    final signedQuantity = _isIncrease ? quantity : -quantity;

    // UI only — no persistence
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Stock ${signedQuantity > 0 ? 'increased' : 'decreased'} by ${quantity}',
        ),
      ),
    );

    Navigator.pop(context);
  }
}
