import 'package:flutter/material.dart';

class AdjustStockDialog extends StatefulWidget {
  final int currentStock;

  const AdjustStockDialog({super.key, required this.currentStock});

  @override
  State<AdjustStockDialog> createState() => _AdjustStockDialogState();
}

class _AdjustStockDialogState extends State<AdjustStockDialog> {
  final controller = TextEditingController();
  String reason = "Purchase";

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Adjust Stock"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Current stock: ${widget.currentStock}"),
          const SizedBox(height: 12),
          TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: "Adjustment (+ / -)",
            ),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField(
            value: reason,
            items: const [
              DropdownMenuItem(value: "Purchase", child: Text("Purchase")),
              DropdownMenuItem(value: "Correction", child: Text("Correction")),
              DropdownMenuItem(value: "Damage", child: Text("Damage")),
            ],
            onChanged: (v) => reason = v as String,
          ),
        ],
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text("Cancel")),
        ElevatedButton(
          onPressed: () {
            final delta = int.tryParse(controller.text) ?? 0;
            Navigator.pop(context, delta);
          },
          child: const Text("Apply"),
        ),
      ],
    );
  }
}
