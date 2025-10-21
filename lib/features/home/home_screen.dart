// TODO Implement this library.
import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/features/auth/screens/login_screen.dart';
import 'package:cardioroad/features/settings/settings_screen.dart';
import 'package:cardioroad/features/history/history_screen.dart';
import 'package:cardioroad/features/emergency/emergency_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // No futuro, este nome virá dos dados do utilizador após o login
  final String userName = "Nathalia";

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  // Função genérica para abrir o Google Maps com uma pesquisa
  Future<void> _openGoogleMapsSearch(String query) async {
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
      if (mounted) {
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
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: const Text('Assistente de Viagem',
            style:
                TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
        automaticallyImplyLeading: false, // Remove a seta de "voltar"
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined, color: AppColors.white),
            tooltip: 'Configurações',
            onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const SettingsScreen())),
          ),
          IconButton(
            icon: const Icon(Icons.logout, color: AppColors.white),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWelcomeHeader(),
              const SizedBox(height: 24),
              _buildPartnersBanner(),
              const SizedBox(height: 24),
              _buildSectionTitle('Serviços Próximos'),
              const SizedBox(height: 16),
              _buildServicesGrid(),
              const SizedBox(height: 24),
              _buildSectionTitle('Acesso Rápido'),
              const SizedBox(height: 16),
              _buildQuickAccessButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Text(
      'Olá, $userName!\nComo podemos ajudar na sua viagem hoje?',
      style: const TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.bold,
        color: AppColors.darkText,
      ),
    );
  }

  Widget _buildPartnersBanner() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () {
          // TODO: Navegar para a tela de parceiros quando ela for criada
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Tela de parceiros em desenvolvimento!')));
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              colors: [AppColors.primary, Colors.blue.shade700],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: const Row(
            children: [
              Icon(FontAwesomeIcons.star, color: Colors.white, size: 40),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Clube de Descontos',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'Poupe 10% em empresas parceiras!',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                  ],
                ),
              ),
              Icon(Icons.arrow_forward_ios, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
    );
  }

  Widget _buildServicesGrid() {
    return GridView.count(
      crossAxisCount: 4,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildServiceButton(
            icon: FontAwesomeIcons.hospital,
            label: 'Hospitais',
            onTap: () => _openGoogleMapsSearch('hospital')),
        _buildServiceButton(
            icon: FontAwesomeIcons.pills,
            label: 'Farmácias',
            onTap: () => _openGoogleMapsSearch('farmácia')),
        _buildServiceButton(
            icon: FontAwesomeIcons.gasPump,
            label: 'Postos',
            onTap: () => _openGoogleMapsSearch('posto de gasolina')),
        _buildServiceButton(
            icon: FontAwesomeIcons.hotel,
            label: 'Hotéis',
            onTap: () => _openGoogleMapsSearch('hotel')),
      ],
    );
  }

  Widget _buildServiceButton(
      {required IconData icon,
      required String label,
      required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            child: FaIcon(icon, color: AppColors.primary, size: 24),
          ),
          const SizedBox(height: 8),
          Text(label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: AppColors.darkText)),
        ],
      ),
    );
  }

  Widget _buildQuickAccessButtons() {
    return Column(
      children: [
        _buildQuickAccessTile(
          icon: FontAwesomeIcons.chartLine,
          title: 'Meu Histórico de Saúde',
          subtitle: 'Glicemia, pressão e mais',
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const HistoryScreen())),
        ),
        const SizedBox(height: 12),
        _buildQuickAccessTile(
          icon: FontAwesomeIcons.kitMedical,
          title: 'Ficha de Emergência',
          subtitle: 'Meus dados e contactos',
          onTap: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const EmergencyScreen())),
        ),
      ],
    );
  }

  Widget _buildQuickAccessTile(
      {required IconData icon,
      required String title,
      required String subtitle,
      required VoidCallback onTap}) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        onTap: onTap,
        leading: FaIcon(icon, color: AppColors.primary, size: 22),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle:
            Text(subtitle, style: const TextStyle(color: AppColors.greyText)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }
}
