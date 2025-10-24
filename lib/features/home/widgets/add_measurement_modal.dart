import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/features/history/models/health_measurement.dart';
import 'package:cardioroad/features/history/services/history_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

// O Enum permanece o mesmo
enum MeasurementInputType {
  glicemia,
  pressaoArterial,
  batimentosCardiacos,
}

class AddMeasurementModal extends StatefulWidget {
  final MeasurementInputType type;

  const AddMeasurementModal({super.key, required this.type});

  @override
  State<AddMeasurementModal> createState() => _AddMeasurementModalState();
}

class _AddMeasurementModalState extends State<AddMeasurementModal> {
  final _formKey = GlobalKey<FormState>();
  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();
  bool _isLoading = false;

  final HistoryService _historyService =
      HistoryService(); // Mantido por consistência

  @override
  void dispose() {
    _controller1.dispose();
    _controller2.dispose();
    super.dispose();
  }

  String _getTitle() {
    switch (widget.type) {
      case MeasurementInputType.glicemia:
        return 'Adicionar Glicemia';
      case MeasurementInputType.pressaoArterial:
        return 'Adicionar Pressão Arterial';
      case MeasurementInputType.batimentosCardiacos:
        return 'Adicionar Batimentos Cardíacos';
    }
  }

  // --- FUNÇÃO MODIFICADA PARA BURLAR O FIRESTORE E RETORNAR O VALOR ---
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        throw Exception('Utilizador não autenticado.');
      }

      String valueToReturn; // Novo: Variável para armazenar o valor formatado

      switch (widget.type) {
        case MeasurementInputType.glicemia:
        case MeasurementInputType.batimentosCardiacos:
          valueToReturn = _controller1.text;
          break;
        case MeasurementInputType.pressaoArterial:
          // Formata o valor de Pressão como string "Sistólica/Diastólica"
          valueToReturn = "${_controller1.text}/${_controller2.text}";
          break;
      }

      // SIMULAÇÃO DE SALVAMENTO
      await Future.delayed(const Duration(seconds: 1));

      if (mounted) {
        // Agora, ele POP o modal RETORNANDO a String formatada.
        Navigator.of(context).pop(valueToReturn);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Medição salva com sucesso!'),
              backgroundColor: AppColors.success),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Erro ao salvar: ${e.toString()}'),
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
  // --- FIM DA FUNÇÃO MODIFICADA ---

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(_getTitle(),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            if (widget.type == MeasurementInputType.pressaoArterial)
              Row(
                children: [
                  Expanded(
                      child: _buildTextField(_controller1, 'Sistólica (MAX)')),
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('/', style: TextStyle(fontSize: 24))),
                  Expanded(
                      child: _buildTextField(_controller2, 'Diastólica (MIN)')),
                ],
              )
            else
              _buildTextField(_controller1, 'Valor'),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _isLoading ? null : _save,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 24,
                      width: 24,
                      child: CircularProgressIndicator(color: Colors.white))
                  : const Text('Salvar Medição',
                      style: TextStyle(color: Colors.white, fontSize: 16)),
            )
          ],
        ),
      ),
    );
  }

  TextFormField _buildTextField(
      TextEditingController controller, String label) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Inválido';
        if (int.tryParse(value) == null &&
            widget.type != MeasurementInputType.pressaoArterial)
          return 'Apenas números';
        return null;
      },
    );
  }
}
