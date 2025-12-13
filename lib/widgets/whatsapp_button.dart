import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class WhatsAppButton extends StatelessWidget {
  const WhatsAppButton({super.key});

  void _openWhatsApp() {
    final Uri url = Uri.parse(
      "https://wa.me/966500000000?text=مرحباً، اريد الاستفسار عن المنتجات.",
    );
    launchUrl(url);
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 25,
      right: 25,
      child: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: _openWhatsApp,
        child: FaIcon(FontAwesomeIcons.whatsapp),
      ),
    );
  }
}
