import 'package:flutter/material.dart';
import 'package:cardioroad/features/emergency/models/emergency_contact.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactCard extends StatelessWidget {
  final EmergencyContact contact;

  const ContactCard({super.key, required this.contact});

  Future<void> _makePhoneCall(BuildContext context) async {
    final Uri launchUri = Uri(
      scheme: 'tel',
      path: contact.phoneNumber,
    );
    try {
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        throw 'Não foi possível ligar para ${contact.phoneNumber}';
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString()), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: const CircleAvatar(
          child: Icon(Icons.person),
        ),
        title: Text(contact.name, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(contact.relationship),
        trailing: IconButton(
          icon: const Icon(Icons.call, color: Colors.green, size: 28),
          tooltip: 'Ligar para ${contact.name}',
          onPressed: () => _makePhoneCall(context),
        ),
      ),
    );
  }
}
