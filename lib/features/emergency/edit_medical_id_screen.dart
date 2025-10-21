import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';

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

  @override
  void initState() {
    super.initState();
    // Preenche os campos do formulário com os dados recebidos
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
    // Limpa os controllers para evitar fugas de memória
    _bloodTypeController.dispose();
    _allergiesController.dispose();
    _medicationsController.dispose();
    _doctorController.dispose();
    super.dispose();
  }

  void _saveForm() {
    // Valida o formulário
    if (_formKey.currentState!.validate()) {
      // Cria um mapa com os dados atualizados
      final updatedData = {
        'bloodType': _bloodTypeController.text,
        'allergies': _allergiesController.text,
        'medications': _medicationsController.text,
        'doctor': _doctorController.text,
      };
      // Fecha a tela e retorna os dados atualizados para a tela anterior (emergency_screen)
      Navigator.of(context).pop(updatedData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Ficha Médica'),
        backgroundColor: AppColors.darkBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _saveForm,
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
                onPressed: _saveForm,
                child: const Text('Salvar Alterações',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
