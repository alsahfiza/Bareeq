import 'package:flutter/material.dart';
import '../../shared/models/app_settings_model.dart';
import '../../shared/services/settings_service.dart';
import '../layout/admin_layout.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final _service = SettingsService();

  late TextEditingController deliveryFee;
  late TextEditingController freeThreshold;
  late TextEditingController vatNumber;

  @override
  Widget build(BuildContext context) {
    return AdminLayout(
      title: 'Settings',
      body: StreamBuilder<AppSettings>(
        stream: _service.getSettings(),
        builder: (_, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final settings = snapshot.data!;

          deliveryFee =
              TextEditingController(text: settings.deliveryFee.toString());
          freeThreshold = TextEditingController(
              text: settings.freeDeliveryThreshold.toString());
          vatNumber = TextEditingController(
              text: settings.vatRegistrationNumber);

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: vatNumber,
                  decoration: const InputDecoration(
                    labelText: 'VAT Registration Number',
                  ),
                ),
                TextField(
                  controller: deliveryFee,
                  decoration:
                      const InputDecoration(labelText: 'Delivery Fee'),
                  keyboardType: TextInputType.number,
                ),
                TextField(
                  controller: freeThreshold,
                  decoration: const InputDecoration(
                      labelText: 'Free Delivery Above'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await _service.saveSettings(
                      AppSettings(
                        deliveryFee:
                            double.parse(deliveryFee.text),
                        freeDeliveryThreshold:
                            double.parse(freeThreshold.text),
                        vatRegistrationNumber: vatNumber.text,
                      ),
                    );
                  },
                  child: const Text('Save'),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
