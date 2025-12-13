import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/whatsapp_button.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            const Text("تواصل معنا",
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),

            const SizedBox(height: 20),

            const Text(
              "الجوال: 0500000000",
              style: TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 10),

            const Text(
              "الموقع: جدة - المملكة العربية السعودية",
              style: TextStyle(fontSize: 22),
            ),

            const SizedBox(height: 20),

            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.teal),
              onPressed: () {
                launchUrl(Uri.parse("https://wa.me/966500000000"));
              },
              icon: FaIcon(FontAwesomeIcons.whatsapp),
              label: const Text("تواصل عبر WhatsApp"),
            ),
            const WhatsAppButton(),
          ],
        ),
      ),
    );
  }
}
