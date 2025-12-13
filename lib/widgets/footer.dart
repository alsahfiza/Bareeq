import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  const Footer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      color: Colors.black12,
      child: const Center(
        child: Text(
          "© 2025 Bareeq Stores — جميع الحقوق محفوظة",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
