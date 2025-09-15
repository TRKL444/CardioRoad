import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';

class MedicalIdCard extends StatelessWidget {
  const MedicalIdCard({super.key});

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
            const Text(
              'Minha Ficha Médica',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            ),
            const Divider(height: 24),
            _buildInfoRow('Tipo Sanguíneo:', 'O+'),
            _buildInfoRow('Alergias:', 'Nenhuma conhecida'),
            _buildInfoRow('Medicamentos:', 'Metformina 500mg (2x ao dia)'),
            _buildInfoRow('Médico:', 'Dr. Carlos Andrade'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(color: Colors.grey[600])),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
