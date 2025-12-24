import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/product_form_provider.dart';

class ProductFormPage extends ConsumerWidget {
  const ProductFormPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productFormProvider);
    final notifier = ref.read(productFormProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Product')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: ListView(
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Name'),
              onChanged: notifier.updateName,
              controller: TextEditingController(text: state.name),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'SKU'),
              onChanged: notifier.updateSku,
              controller: TextEditingController(text: state.sku),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Barcode'),
              onChanged: notifier.updateBarcode,
              controller: TextEditingController(text: state.barcode),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Category'),
              onChanged: notifier.updateCategory,
              controller: TextEditingController(text: state.category),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onChanged: (v) =>
                  notifier.updatePrice(double.tryParse(v) ?? 0),
              controller:
                  TextEditingController(text: state.price.toString()),
            ),
            TextField(
              decoration: const InputDecoration(labelText: 'Cost'),
              keyboardType: TextInputType.number,
              onChanged: (v) =>
                  notifier.updateCost(double.tryParse(v) ?? 0),
              controller:
                  TextEditingController(text: state.cost.toString()),
            ),
            SwitchListTile(
              title: const Text('Active'),
              value: state.isActive,
              onChanged: notifier.toggleActive,
            ),
            const SizedBox(height: 16),
            if (state.error != null)
              Text(
                state.error!,
                style: const TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed:
                  state.submitting ? null : () => notifier.submit(),
              child: state.submitting
                  ? const CircularProgressIndicator()
                  : const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}
