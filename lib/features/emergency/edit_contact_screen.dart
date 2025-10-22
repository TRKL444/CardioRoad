import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/features/emergency/models/emergency_contact.dart';

class EditContactScreen extends StatefulWidget {
  // Se um contato for passado, estamos a editar. Se for nulo, estamos a criar um novo.
  final EmergencyContact? contact;

  const EditContactScreen({super.key, this.contact});

  @override
  State<EditContactScreen> createState() => _EditContactScreenState();
}

class _EditContactScreenState extends State<EditContactScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _relationshipController;
  late final TextEditingController _phoneController;

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    // Preenche os campos com os dados do contato, se estiver a editar
    _nameController = TextEditingController(text: widget.contact?.name);
    _relationshipController =
        TextEditingController(text: widget.contact?.relationship);
    _phoneController = TextEditingController(text: widget.contact?.phoneNumber);
  }

  @override
  void dispose() {
    // Limpa os controllers para evitar fugas de memória
    _nameController.dispose();
    _relationshipController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _saveForm() {
    // Valida o formulário
    if (_formKey.currentState!.validate()) {
      // Cria um novo objeto EmergencyContact com os dados do formulário
      final newContact = EmergencyContact(
        name: _nameController.text,
        relationship: _relationshipController.text,
        phoneNumber: _phoneController.text,
      );
      // Fecha a tela e retorna o contato (novo ou atualizado) para a tela anterior
      Navigator.of(context).pop(newContact);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            widget.contact == null ? 'Adicionar Contato' : 'Editar Contato'),
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
                controller: _nameController,
                decoration: const InputDecoration(
                    labelText: 'Nome', border: OutlineInputBorder()),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                textCapitalization: TextCapitalization.words,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _relationshipController,
                decoration: const InputDecoration(
                    labelText: 'Parentesco (ex: Mãe, Médico)',
                    border: OutlineInputBorder()),
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
                textCapitalization: TextCapitalization.sentences,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _phoneController,
                decoration: const InputDecoration(
                    labelText: 'Número de Telefone',
                    border: OutlineInputBorder()),
                keyboardType: TextInputType.phone,
                validator: (value) =>
                    (value?.isEmpty ?? true) ? 'Campo obrigatório' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 50, vertical: 15),
                    textStyle: const TextStyle(fontSize: 16)),
                onPressed: _saveForm,
                child: const Text('Salvar Contato',
                    style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
