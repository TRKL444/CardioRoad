import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/features/emergency/models/emergency_contact.dart';
import 'package:cardioroad/features/emergency/widgets/contact_card.dart';
import 'package:cardioroad/features/emergency/widgets/medical_id_card.dart';
import 'package:cardioroad/features/emergency/edit_contact_screen.dart';
import 'package:cardioroad/features/emergency/edit_medical_id_screen.dart'; // Importa a tela de edição médica
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final _auth = FirebaseAuth.instance;

  // --- MOCK DATA AGORA É GESTÃO DE ESTADO LOCAL ---
  // Este mapa será atualizado quando a ficha médica for salva.
  Map<String, String> _medicalData = {
    'bloodType': '',
    'allergies': '',
    'medications': '',
    'doctor': '',
  };

  // Esta lista será atualizada quando um novo contato for adicionado.
  List<EmergencyContact> _emergencyContacts = [
    const EmergencyContact(
      name: 'Eliane',
      relationship: 'Mãe',
      phoneNumber: '() 9 9999-9999',
    ),
  ];
  // ----------------------------------------------------

  // Função para navegar e adicionar um novo contacto
  void _addContact() async {
    final user = _auth.currentUser;
    if (user == null) return;

    // Abre a tela de formulário e espera o EmergencyContact ser retornado
    final newContact = await Navigator.of(context).push<EmergencyContact>(
      MaterialPageRoute(
        builder: (context) => const EditContactScreen(),
      ),
    );

    // Se o contacto foi salvo (retornado), atualiza o estado local.
    if (newContact != null) {
      setState(() {
        _emergencyContacts.add(newContact);
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Novo contato salvo com sucesso!'),
              backgroundColor: AppColors.success),
        );
      }
    }
  }

  // Função para navegar e editar a ficha médica
  void _editMedicalId() async {
    // Abre a tela de edição e espera o Map<String, String> com os novos dados
    final result = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(
        builder: (context) => EditMedicalIdScreen(initialData: _medicalData),
      ),
    );

    // Se a ficha médica foi editada (o mapa foi retornado), atualiza o estado
    if (result != null) {
      setState(() {
        _medicalData = result;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Ficha médica atualizada com sucesso!'),
              backgroundColor: AppColors.success),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Ficha de Emergência')),
        body: const Center(
            child: Text('Faça login para gerir os seus contactos.')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ficha de Emergência'),
        backgroundColor: AppColors.darkBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.lightGreyBackground,
      // Não há mais StreamBuilder - usamos a lista local
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Ficha Médica
          GestureDetector(
            onTap: _editMedicalId, // Chama a função de edição
            child: MedicalIdCard(medicalData: _medicalData),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Contactos de Emergência',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.darkText)),
              IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.primary),
                onPressed: _addContact,
                tooltip: 'Adicionar Contacto',
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Lista de Contactos
          ..._emergencyContacts
              .map((contact) => ContactCard(contact: contact))
              .toList(),
        ],
      ),
    );
  }

  // Widget para quando a lista de contactos está vazia (Não é mais usada, mas mantida como fallback)
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Contactos de Emergência',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              IconButton(
                icon: const Icon(Icons.add_circle, color: AppColors.primary),
                onPressed: _addContact,
                tooltip: 'Adicionar Contacto',
              ),
            ],
          ),
          const Expanded(
            child: Center(
              child: Text('Nenhum contacto de emergência adicionado.'),
            ),
          ),
        ],
      ),
    );
  }
}
