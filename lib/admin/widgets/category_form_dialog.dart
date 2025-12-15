import 'package:flutter/material.dart';
import '../../shared/models/category_model.dart';
import '../../shared/services/category_service.dart';

class CategoryFormDialog extends StatefulWidget {
  final CategoryModel? category;
  const CategoryFormDialog({super.key, this.category});

  @override
  State<CategoryFormDialog> createState() => _CategoryFormDialogState();
}

class _CategoryFormDialogState extends State<CategoryFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _service = CategoryService();

  late TextEditingController name;
  late TextEditingController order;
  bool isActive = true;

  @override
  void initState() {
    super.initState();
    name = TextEditingController(text: widget.category?.name ?? '');
    order = TextEditingController(
        text: widget.category?.order.toString() ?? '0');
    isActive = widget.category?.isActive ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.category == null ? 'Add Category' : 'Edit Category'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              controller: name,
              decoration: const InputDecoration(labelText: 'Category Name'),
              validator: (v) => v!.isEmpty ? 'Required' : null,
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
          child: const Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
        ElevatedButton(
          child: const Text('Save'),
          onPressed: () async {
            if (!_formKey.currentState!.validate()) return;

            final category = CategoryModel(
              id: widget.category?.id ?? '',
              name: name.text,
              isActive: isActive,
              order: int.parse(order.text),
            );

            widget.category == null
                ? await _service.addCategory(category)
                : await _service.updateCategory(category);

            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
