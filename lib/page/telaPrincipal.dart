import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/page/pageLogin.dart';

// Importamos as telas necessárias
import 'package:cardioroad/features/history/history_screen.dart';
import 'package:cardioroad/features/settings/settings_screen.dart';
import 'package:cardioroad/features/emergency/emergency_screen.dart'; // IMPORTAÇÃO DA NOVA TELA
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String userName = "Nathalia";
  String _currentGlucoseValue = "---";
  String _lastMeasurementStatus = "Nenhuma medição hoje";

  void _logout() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
  }

  Future<void> _openGoogleMapsSearch() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Obtendo sua localização para abrir o mapa...')),
    );

    try {
      await _determinePosition();
      const query = 'posto de saúde';
      final Uri url = Uri.parse('https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(query)}');

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw 'Não foi possível abrir o Google Maps.';
      }

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro: ${e.toString().replaceAll("Exception: ", "")}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _showAddMeasurementSheet() {
    final controller = TextEditingController();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.fromLTRB(20, 20, 20, MediaQuery.of(context).viewInsets.bottom + 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Adicionar Nova Medição',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Valor da glicemia (mg/dL)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.isNotEmpty) {
                    setState(() {
                      _currentGlucoseValue = controller.text;
                      _lastMeasurementStatus = "Última medição: Agora";
                    });
                    Navigator.of(context).pop();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Salvar Medição', style: TextStyle(color: Colors.white, fontSize: 16)),
              )
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.lightGreyBackground,
      appBar: AppBar(
        backgroundColor: AppColors.darkBackground,
        elevation: 0,
        title: const Text('Painel de Controle', style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: AppColors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Configurações',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsScreen()),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Sair',
            onPressed: _logout,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildWelcomeHeader(),
              const SizedBox(height: 32),
              _buildGlucoseCard(),
              const SizedBox(height: 24),
              _buildQuickActionsTitle(),
              const SizedBox(height: 16),
              _buildActionButtons(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Bem-vinda de volta,', style: TextStyle(color: AppColors.greyText, fontSize: 18)),
        Text(userName, style: TextStyle(color: AppColors.darkText, fontSize: 32, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildGlucoseCard() {
    return Card(
      elevation: 4,
      shadowColor: AppColors.primary.withOpacity(0.2),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [AppColors.primary, Colors.blue.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const Text('Seu nível de glicemia atual', style: TextStyle(color: AppColors.white, fontSize: 16)),
            const SizedBox(height: 12),
            Text('$_currentGlucoseValue mg/dL', style: const TextStyle(color: AppColors.white, fontSize: 48, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(_lastMeasurementStatus, style: TextStyle(color: AppColors.lightGreyBackground)),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _showAddMeasurementSheet,
              icon: const Icon(Icons.add, color: AppColors.primary),
              label: const Text('Adicionar Nova Medição', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActionsTitle() {
    return Text('Ações Rápidas', style: TextStyle(color: AppColors.darkText, fontSize: 20, fontWeight: FontWeight.bold));
  }
  
  // WIDGET DE AÇÕES RÁPIDAS ATUALIZADO
  Widget _buildActionButtons() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildActionButton(
                icon: FontAwesomeIcons.chartLine,
                label: 'Histórico',
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const HistoryScreen()),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionButton(
                icon: FontAwesomeIcons.hospital,
                label: 'Postos de Saúde',
                onTap: _openGoogleMapsSearch,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // BOTÃO DE EMERGÊNCIA ADICIONADO AQUI
        _buildActionButton(
          icon: FontAwesomeIcons.kitMedical,
          label: 'Ficha de Emergência',
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => EmergencyScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Card(
        elevation: 2,
        shadowColor: Colors.black.withOpacity(0.1),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FaIcon(icon, size: 40, color: AppColors.primary),
              const SizedBox(height: 12),
              Text(label, textAlign: TextAlign.center, style: TextStyle(color: AppColors.darkText, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
      ),
    );
  }
  
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Os serviços de localização estão desativados. Por favor, ative o GPS.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('As permissões de localização foram negadas.');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      return Future.error('As permissões de localização foram negadas permanentemente.');
    }
    return await Geolocator.getCurrentPosition();
  }
}

