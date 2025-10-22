import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class ServicesScreen extends StatelessWidget {
  const ServicesScreen({super.key});

  Future<void> _openGoogleMapsSearch(String query, BuildContext context) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('A procurar por "$query" perto de si...')),
    );
    try {
      final Uri url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');
      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Não foi possível abrir o Google Maps.';
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Erro: ${e.toString().replaceAll("Exception: ", "")}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Serviços Próximos'),
        backgroundColor: AppColors.darkBackground,
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Encontre o que precisa na sua viagem',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText),
            ),
            const SizedBox(height: 24),
            GridView.count(
              crossAxisCount: 2, // 2 colunas para botões maiores
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio:
                  1.2, // Ajusta a proporção para os botões ficarem mais altos
              children: [
                _buildServiceButton(
                  icon: FontAwesomeIcons.hospital,
                  label: 'Hospitais & Postos',
                  onTap: () =>
                      _openGoogleMapsSearch('hospital posto de saude', context),
                ),
                _buildServiceButton(
                  icon: FontAwesomeIcons.pills,
                  label: 'Farmácias',
                  onTap: () => _openGoogleMapsSearch('farmácia', context),
                ),
                _buildServiceButton(
                  icon: FontAwesomeIcons.gasPump,
                  label: 'Postos de Gasolina',
                  onTap: () =>
                      _openGoogleMapsSearch('posto de gasolina', context),
                ),
                _buildServiceButton(
                  icon: FontAwesomeIcons.hotel,
                  label: 'Hotéis e Pousadas',
                  onTap: () => _openGoogleMapsSearch('hotel pousada', context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(icon, color: AppColors.primary, size: 40),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.darkText,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
