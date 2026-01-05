import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class BarcodeInputField extends StatelessWidget {
  final TextEditingController controller;

  const BarcodeInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Barcode',
        border: const OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          onPressed: () async {
            final code = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (_) => const _BarcodeScannerPage(),
              ),
            );
            if (code != null) {
              controller.text = code;
            }
          },
        ),
      ),
    );
  }
}

class _BarcodeScannerPage extends StatelessWidget {
  const _BarcodeScannerPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan Barcode')),
      body: MobileScanner(
        onDetect: (capture) {
          final barcode = capture.barcodes.first.rawValue;
          if (barcode != null) {
            Navigator.pop(context, barcode);
          }
        },
      ),
    );
  }
}
