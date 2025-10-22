import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/features/emergency/models/emergency_contact.dart';
import 'package:cardioroad/features/emergency/widgets/contact_card.dart';
import 'package:cardioroad/features/emergency/widgets/medical_id_card.dart';
import 'package:cardioroad/features/emergency/edit_contact_screen.dart';

// Importações do Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  // Função para navegar e adicionar um novo contacto
  void _addContact() async {
    final user = _auth.currentUser;
    if (user == null) return; // Garante que o utilizador está logado

    // Abre a tela de formulário para obter os dados do novo contacto
    final newContact = await Navigator.of(context).push<EmergencyContact>(
      MaterialPageRoute(
        builder: (context) => const EditContactScreen(),
      ),
    );

    // Se o utilizador salvou um novo contacto, guarda-o no Firestore
    if (newContact != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('emergency_contacts')
          .add({
        'name': newContact.name,
        'relationship': newContact.relationship,
        'phoneNumber': newContact.phoneNumber,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;

    // Se o utilizador não estiver logado, mostra uma mensagem
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
      // Usamos um StreamBuilder para ouvir as alterações na base de dados em tempo real
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(user.uid)
            .collection('emergency_contacts')
            .snapshots(),
        builder: (context, snapshot) {
          // Enquanto os dados estão a ser carregados, mostra um indicador de progresso
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // Se ocorrer um erro
          if (snapshot.hasError) {
            return const Center(
                child: Text('Ocorreu um erro ao carregar os contactos.'));
          }

          // Se não houver dados
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return _buildEmptyState();
          }

          // Processa a lista de contactos vinda do Firestore
          final emergencyContacts = snapshot.data!.docs.map((doc) {
            final data = doc.data() as Map<String, dynamic>;
            return EmergencyContact(
              name: data['name'] ?? '',
              relationship: data['relationship'] ?? '',
              phoneNumber: data['phoneNumber'] ?? '',
            );
          }).toList();

          // Constrói a UI com os dados
          return ListView(
            padding: const EdgeInsets.all(16.0),
            children: [
              // TODO: Conectar a Ficha Médica ao Firebase
              // GestureDetector(
              //   onTap: () => _editMedicalId(medicalData),
              //   child: MedicalIdCard(medicalData: medicalData),
              // ),
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
                    icon:
                        const Icon(Icons.add_circle, color: AppColors.primary),
                    onPressed: _addContact,
                    tooltip: 'Adicionar Contacto',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ...emergencyContacts
                  .map((contact) => ContactCard(contact: contact))
                  .toList(),
            ],
          );
        },
      ),
    );
  }

  // Widget para quando a lista de contactos está vazia
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
