import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/features/emergency/models/emergency_contact.dart';
import 'package:cardioroad/features/emergency/widgets/contact_card.dart';
import 'package:cardioroad/features/emergency/widgets/medical_id_card.dart';

class EmergencyScreen extends StatelessWidget {
   EmergencyScreen({super.key});

  // Lista de dados de exemplo (mock)
  final List<EmergencyContact> emergencyContacts = [
    EmergencyContact(name: 'Ana Silva', relationship: 'Mãe', phoneNumber: '+5569999998888'),
    EmergencyContact(name: 'Dr. Carlos Andrade', relationship: 'Médico', phoneNumber: '+5569988887777'),
    EmergencyContact(name: 'João Pereira', relationship: 'Amigo', phoneNumber: '+5569977776666'),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ficha de Emergência'),
        backgroundColor: AppColors.darkBackground,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.lightGreyBackground,
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Card da Ficha Médica
          const MedicalIdCard(),
          const SizedBox(height: 24),

          // Cabeçalho da seção de contatos
           Text(
            'Contatos de Emergência',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.darkText,
            ),
          ),
          const SizedBox(height: 16),

          // Lista de Contatos
          ...emergencyContacts.map((contact) => ContactCard(contact: contact)).toList(),
        ],
      ),
    );
  }
}
