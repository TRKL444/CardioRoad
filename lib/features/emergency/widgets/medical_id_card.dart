import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';

class MedicalIdCard extends StatelessWidget {
  // O widget agora espera receber os dados médicos para exibi-los
  final Map<String, String> medicalData;
  const MedicalIdCard({super.key, required this.medicalData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Minha Ficha Médica',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primary,
                  ),
                ),
                // Ícone de "editar" para dar uma dica visual ao usuário
                Icon(Icons.edit, color: Colors.grey[400], size: 20),
              ],
            ),
            const Divider(height: 24),
            // Os dados agora são lidos do mapa de dados recebido
            _buildInfoRow(
                'Tipo Sanguíneo:', medicalData['bloodType'] ?? 'Não informado'),
            _buildInfoRow(
                'Alergias:', medicalData['allergies'] ?? 'Não informado'),
            _buildInfoRow(
                'Medicamentos:', medicalData['medications'] ?? 'Não informado'),
            _buildInfoRow('Médico:', medicalData['doctor'] ?? 'Não informado'),
          ],
        ),
      ),
    );
  }

  // Widget auxiliar para criar cada linha de informação
  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600])),
          const SizedBox(width: 8),
          // O `Expanded` garante que o texto longo quebre a linha corretamente
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }
}
