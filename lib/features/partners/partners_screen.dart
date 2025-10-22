import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PartnersScreen extends StatelessWidget {
  const PartnersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clube de Descontos'),
        backgroundColor: AppColors.darkBackground,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const Text(
            'Parceiros Exclusivos',
            style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText),
          ),
          const SizedBox(height: 8),
          const Text(
            'Apresente o seu app e ganhe descontos!',
            style: TextStyle(fontSize: 16, color: AppColors.greyText),
          ),
          const SizedBox(height: 24),
          _buildPartnerCard(
            icon: FontAwesomeIcons.pills,
            name: 'Farmácia Bem-Estar',
            category: 'Farmácia',
            discount: '10% de desconto em medicamentos',
          ),
          _buildPartnerCard(
            icon: FontAwesomeIcons.hotel,
            name: 'Hotel Central',
            category: 'Hospedagem',
            discount: '15% de desconto na diária',
          ),
          _buildPartnerCard(
            icon: FontAwesomeIcons.gasPump,
            name: 'Posto Viajante',
            category: 'Combustível',
            discount: '5% de desconto no abastecimento',
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerCard({
    required IconData icon,
    required String name,
    required String category,
    required String discount,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            FaIcon(icon, color: AppColors.primary, size: 32),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 4),
                  Text(category,
                      style: const TextStyle(color: AppColors.greyText)),
                  const SizedBox(height: 8),
                  Text(discount,
                      style: const TextStyle(
                          color: AppColors.success,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
