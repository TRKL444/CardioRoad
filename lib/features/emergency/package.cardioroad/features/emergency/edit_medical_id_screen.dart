import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';

// Importações do Firebase
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EditMedicalIdScreen extends StatefulWidget {
  // Recebemos os dados atuais para preencher o formulário
  final Map<String, String> initialData;

  const EditMedicalIdScreen({super.key, required this.initialData});

  @override
  State<EditMedicalIdScreen> createState() => _EditMedicalIdScreenState();
}

class _EditMedicalIdScreenState extends State<EditMedicalIdScreen> {
  late final TextEditingController _bloodTypeController;
  late final TextEditingController _allergiesController;
  late final TextEditingController _medicationsController;
  late final TextEditingController _doctorController;

  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _bloodTypeController =
        TextEditingController(text: widget.initialData['bloodType']);
    _allergiesController =
        TextEditingController(text: widget.initialData['allergies']);
    _medicationsController =
        TextEditingController(text: widget.initialData['medications']);
    _doctorController =
        TextEditingController(text: widget.initialData['doctor']);
  }

  @override
  void dispose() {
    _bloodTypeController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _doctorController.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Nenhum utilizador logado para salvar os dados.');
      }

      final updatedData = {
        'bloodType': _bloodTypeController.text,
        'allergies': _allergiesController.text,
        'medications': _medicationsController.text,
        'doctor': _doctorController.text,
        'updatedAt':
            FieldValue.serverTimestamp(), // Guarda a data da última atualização
      };

      // Salva (ou atualiza) os dados como um único documento na sub-coleção 'medical_id'
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('medical_id')
          .doc(
              'data') // Usamos um ID fixo para sempre atualizar o mesmo documento
          .set(
              updatedData,
              SetOptions(
                  merge: true)); // `merge: true` para não apagar outros campos

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Ficha médica salva com sucesso!'),
              backgroundColor: AppColors.success),
        );
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao salvar os dados: ${e.toString()}'),
              backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Ficha Médica'),
        backgroundColor: AppColors.darkBackground,
        actions: [
          IconButton(
            icon: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2.0))
                : const Icon(Icons.save),
            onPressed: _isLoading ? null : _saveForm,
            tooltip: 'Salvar',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _bloodTypeController,
                decoration: const InputDecoration(
                    labelText: 'Tipo Sanguíneo', border: OutlineInputBorder()),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _allergiesController,
                decoration: const InputDecoration(
                    labelText: 'Alergias', border: OutlineInputBorder()),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _medicationsController,
                decoration: const InputDecoration(
                    labelText: 'Medicamentos Principais',
                    border: OutlineInputBorder()),
                maxLines: 3,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _doctorController,
                decoration: const InputDecoration(
                    labelText: 'Médico Principal',
                    border: OutlineInputBorder()),
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16)),
                onPressed: _isLoading ? null : _saveForm,
                child: _isLoading
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(color: Colors.white))
                    : const Text('Salvar Alterações',
                        style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
