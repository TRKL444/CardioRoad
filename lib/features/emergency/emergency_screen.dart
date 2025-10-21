import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/features/emergency/models/emergency_contact.dart';
import 'package:cardioroad/features/emergency/widgets/contact_card.dart';
import 'package:cardioroad/features/emergency/widgets/medical_id_card.dart';

// --- IMPORTAÇÕES CORRIGIDAS AQUI ---
// Os arquivos de tela estão diretamente em 'emergency', não em 'emergency/widgets'
import 'package:cardioroad/features/emergency/edit_medical_id_screen.dart';
import 'package:cardioroad/features/emergency/edit_contact_screen.dart'
    hide EditMedicalIdScreen;

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  // Os dados agora fazem parte do estado, para que possam ser modificados
  late Map<String, String> _medicalData;
  late List<EmergencyContact> _emergencyContacts;

  @override
  void initState() {
    super.initState();
    // Inicializamos com dados de exemplo (no futuro, virão do back-end)
    _medicalData = {
      'bloodType': 'O+',
      'allergies': 'Nenhuma conhecida',
      'medications': 'Metformina 500mg (2x ao dia)',
      'doctor': 'Dr. Carlos Andrade',
    };
    _emergencyContacts = [
      EmergencyContact(
          name: 'Ana Silva',
          relationship: 'Mãe',
          phoneNumber: '+5569999998888'),
      EmergencyContact(
          name: 'Dr. Carlos Andrade',
          relationship: 'Médico',
          phoneNumber: '+5569988887777'),
    ];
  }

  // Função para navegar e editar a ficha médica
  void _editMedicalId() async {
    final updatedData = await Navigator.of(context).push<Map<String, String>>(
      MaterialPageRoute(
        builder: (context) => EditMedicalIdScreen(initialData: _medicalData),
      ),
    );

    // Se o usuário salvar na tela de edição, atualizamos os dados aqui
    if (updatedData != null) {
      setState(() {
        _medicalData = updatedData;
      });
    }
  }

  // Função para navegar e adicionar um novo contato
  void _addContact() async {
    final newContact = await Navigator.of(context).push<EmergencyContact>(
      MaterialPageRoute(
        builder: (context) => const EditContactScreen(),
      ),
    );

    // Se o usuário salvar na tela de adição, adicionamos o novo contato à lista
    if (newContact != null) {
      setState(() {
        _emergencyContacts.add(newContact);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // O Card da Ficha Médica agora é clicável
          GestureDetector(
            onTap: _editMedicalId,
            child: MedicalIdCard(medicalData: _medicalData),
          ),
          const SizedBox(height: 24),

          // Cabeçalho da seção de contatos com o botão de adicionar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Contatos de Emergência',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle,
                    color: AppColors.primary, size: 28),
                onPressed: _addContact,
                tooltip: 'Adicionar Contato',
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Lista de Contatos
          if (_emergencyContacts.isEmpty)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text('Nenhum contato adicionado.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: AppColors.greyText)),
            )
          else
            // Cria um ContactCard para cada contato na lista
            ..._emergencyContacts
                .map((contact) => ContactCard(contact: contact))
                .toList(),
        ],
      ),
    );
  }
}
