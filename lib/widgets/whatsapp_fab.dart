import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class WhatsappFab extends StatelessWidget {
  const WhatsappFab({super.key});

  Future<void> _launchWhatsapp() async {
    final Uri url = Uri.parse('https://wa.me/917667844210');
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch WhatsApp');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _launchWhatsapp,
      backgroundColor: Colors.green,
      child: const Icon(Icons.chat, color: Colors.white),
    );
  }
}
