import 'package:flutter/material.dart';
import 'barcode_scanner_page.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/animation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/painting.dart';

class BarcodeInputField extends StatelessWidget {
  final TextEditingController controller;

  const BarcodeInputField({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: "Barcode",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        suffixIcon: IconButton(
          icon: const Icon(Icons.qr_code_scanner),
          tooltip: "Scan barcode",
          onPressed: () async {
            final result = await Navigator.push<String>(
              context,
              MaterialPageRoute(
                builder: (_) => const BarcodeScannerPage(),
              ),
            );

            if (result != null && result.isNotEmpty) {
              controller.text = result;
            }
          },
        ),
      ),

      // ✅ HARDWARE SCANNER SUPPORT
      onSubmitted: (_) {
        FocusScope.of(context).unfocus();
      },
    );
  }
}