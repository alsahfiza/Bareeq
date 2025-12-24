import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/inventory_adjustment_reason.dart';
import '../../../domain/commands/inventory_adjustment_command.dart';
import '../../../domain/policies/inventory_adjustment_policy.dart';
import '../../../core/config/inventory_adjustment_providers.dart';

class InventoryAdjustmentDialog extends ConsumerStatefulWidget {
  final String productId;
  final String storeId;

  const InventoryAdjustmentDialog({
    super.key,
    required this.productId,
    required this.storeId,
  });

  @override
  ConsumerState<InventoryAdjustmentDialog> createState() =>
      _InventoryAdjustmentDialogState();
}

class _InventoryAdjustmentDialogState
    extends ConsumerState<InventoryAdjustmentDialog> {
  final _deltaCtrl = TextEditingController();
  final _commentCtrl = TextEditingController();
  InventoryAdjustmentReason _reason =
      InventoryAdjustmentReason.correction;

  String? _error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Adjust Inventory'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _deltaCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Quantity Delta'),
          ),
          const SizedBox(height: 8),
          DropdownButton<InventoryAdjustmentReason>(
            value: _reason,
            items: InventoryAdjustmentReason.values
                .map(
                  (r) => DropdownMenuItem(
                    value: r,
                    child: Text(r.name),
                  ),
                )
                .toList(),
            onChanged: (v) => setState(() => _reason = v!),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _commentCtrl,
            decoration:
                const InputDecoration(labelText: 'Comment (if required)'),
          ),
          if (_error != null) ...[
            const SizedBox(height: 8),
            Text(_error!, style: const TextStyle(color: Colors.red)),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submit,
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Future<void> _submit() async {
    final delta = int.tryParse(_deltaCtrl.text);
    if (delta == null) {
      setState(() => _error = 'Invalid quantity');
      return;
    }

    if (InventoryAdjustmentPolicy.requiresComment(delta) &&
        _commentCtrl.text.trim().isEmpty) {
      setState(() => _error = 'Comment required for this adjustment');
      return;
    }

    try {
      await ref
          .read(adjustInventoryWithSafeguardsProvider)
          .call(
            InventoryAdjustmentCommand(
              productId: widget.productId,
              storeId: widget.storeId,
              delta: delta,
              reason: _reason,
              comment: _commentCtrl.text.trim().isEmpty
                  ? null
                  : _commentCtrl.text.trim(),
            ),
          );
      Navigator.pop(context);
    } catch (e) {
      setState(() => _error = e.toString());
    }
  }
}
