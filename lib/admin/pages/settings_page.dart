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
  final _formKey = GlobalKey<FormState>();

  late TextEditingController deliveryFee;
  late TextEditingController freeThreshold;

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

          deliveryFee = TextEditingController(
              text: settings.deliveryFee.toString());
          freeThreshold = TextEditingController(
              text: settings.freeDeliveryThreshold.toString());

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Delivery Settings',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: deliveryFee,
                    decoration:
                        const InputDecoration(labelText: 'Delivery Fee'),
                    keyboardType: TextInputType.number,
                  ),

                  TextFormField(
                    controller: freeThreshold,
                    decoration: const InputDecoration(
                        labelText: 'Free Delivery Above'),
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton(
                    child: const Text('Save'),
                    onPressed: () async {
                      final updated = AppSettings(
                        deliveryFee:
                            double.parse(deliveryFee.text),
                        freeDeliveryThreshold:
                            double.parse(freeThreshold.text),
                      );

                      await _service.saveSettings(updated);

                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings saved'),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
