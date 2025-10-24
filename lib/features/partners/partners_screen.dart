import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart'; // Import necessário

class PartnersScreen extends StatelessWidget {
  const PartnersScreen({super.key});

  // Função genérica para abrir o Google Maps com uma pesquisa
  Future<void> _launchMapsQuery(String query) async {
    // Codifica a query para ser segura em URL
    final encodedQuery = Uri.encodeComponent(query);
    // Cria o URI do Google Maps para pesquisa
    final Uri url = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=$encodedQuery');

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      // Caso não consiga abrir o URL (ex: falta de app de mapas)
      debugPrint('Não foi possível abrir $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clube de Descontos'),
        backgroundColor: AppColors.darkBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
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
            context, // Passa o context
            icon: FontAwesomeIcons.pills,
            name: 'Farmácia Pague Menos',
            category: 'Farmácia',
            discount: '10% de desconto em medicamentos',
            searchQuery: 'Farmácia Pague Menos', // Pesquisa específica
          ),
          _buildPartnerCard(
            context,
            icon: FontAwesomeIcons.hotel,
            name: 'Hotel Slaviero',
            category: 'Hospedagem',
            discount: '15% de desconto na diária',
            searchQuery: 'Hotel Slaviero Porto Velho',
          ),
          _buildPartnerCard(
            context,
            icon: FontAwesomeIcons.gasPump,
            name: 'Posto Shell',
            category: 'Combustível',
            discount: '5% de desconto no abastecimento',
            searchQuery: 'posto shell',
          ),
        ],
      ),
    );
  }

  // O widget agora recebe o BuildContext e o searchQuery
  Widget _buildPartnerCard(
    BuildContext context, {
    required IconData icon,
    required String name,
    required String category,
    required String discount,
    required String searchQuery,
  }) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        // Usa InkWell para tornar o Card clicável
        onTap: () {
          _launchMapsQuery(searchQuery); // Chama a função ao tocar
          // Opcional: Adicionar feedback visual ao usuário
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('A procurar $name no Google Maps...')),
          );
        },
        borderRadius: BorderRadius.circular(16),
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
              const Icon(Icons.location_on,
                  color: AppColors
                      .primary), // Ícone visual para indicar a ação do mapa
            ],
          ),
        ),
      ),
    );
  }
}
