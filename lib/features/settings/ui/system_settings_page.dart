import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/system_settings_provider.dart';

class SystemSettingsPage extends ConsumerWidget {
  const SystemSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(systemSettingsProvider);
    final notifier = ref.read(systemSettingsProvider.notifier);

    if (state.loading || state.settings == null) {
      return const Center(child: CircularProgressIndicator());
    }

    final s = state.settings!;

    final currencyCtrl =
        TextEditingController(text: s.currencyCode);
    final dateCtrl =
        TextEditingController(text: s.dateFormat);
    final stockCtrl =
        TextEditingController(text: s.defaultMinimumStock.toString());

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'System Settings',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: currencyCtrl,
            decoration:
                const InputDecoration(labelText: 'Currency Code'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: dateCtrl,
            decoration:
                const InputDecoration(labelText: 'Date Format'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: stockCtrl,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Default Minimum Stock',
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              notifier.update(
                s.copyWith(
                  currencyCode: currencyCtrl.text,
                  dateFormat: dateCtrl.text,
                  defaultMinimumStock:
                      int.tryParse(stockCtrl.text) ??
                          s.defaultMinimumStock,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
