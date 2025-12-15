import 'package:flutter/material.dart';
import '../../shared/models/banner_model.dart';
import '../../shared/services/banner_service.dart';

class BannerFormDialog extends StatefulWidget {
  const BannerFormDialog({super.key});

  @override
  State<BannerFormDialog> createState() => _BannerFormDialogState();
}

class _BannerFormDialogState extends State<BannerFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _service = BannerService();

  final imageUrl = TextEditingController();
  final targetId = TextEditingController();
  final order = TextEditingController(text: '0');

  String type = 'category';
  bool isActive = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Banner'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: imageUrl,
              decoration: const InputDecoration(labelText: 'Image URL'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
            ),
            DropdownButtonFormField(
              value: type,
              items: const [
                DropdownMenuItem(value: 'category', child: Text('Category')),
                DropdownMenuItem(value: 'product', child: Text('Product')),
              ],
              onChanged: (v) => setState(() => type = v as String),
              decoration: const InputDecoration(labelText: 'Type'),
            ),
            TextFormField(
              controller: targetId,
              decoration:
                  const InputDecoration(labelText: 'Target ID'),
            ),
            TextFormField(
              controller: order,
              decoration: const InputDecoration(labelText: 'Order'),
              keyboardType: TextInputType.number,
            ),
            SwitchListTile(
              title: const Text('Active'),
              value: isActive,
              onChanged: (v) => setState(() => isActive = v),
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
          child: const Text('Save'),
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            await _service.addBanner(
              BannerModel(
                id: '',
                imageUrl: imageUrl.text,
                type: type,
                targetId: targetId.text,
                isActive: isActive,
                order: int.parse(order.text),
              ),
            );

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
