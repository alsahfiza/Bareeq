import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/whatsapp_button.dart';


class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: const [
            Text("من نحن",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),

            SizedBox(height: 20),

            Text(
              "بريق ستورز — متجر متخصص في بيع جميع منتجات المنظفات والبلاستيك والورقيات بالجملة والتجزئة مع توفير أفضل الأسعار والجودة العالية.",
              textAlign: TextAlign.right,
              style: TextStyle(fontSize: 20),
            ),
            WhatsAppButton(),
          ],
        ),
      ),
    );
  }
}
