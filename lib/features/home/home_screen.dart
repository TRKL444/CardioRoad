import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/features/history/history_screen.dart';
import 'package:cardioroad/features/emergency/emergency_screen.dart';
import 'package:cardioroad/features/settings/settings_screen.dart';
import 'package:cardioroad/features/home/widgets/add_measurement_modal.dart';
import 'package:cardioroad/features/services/services_screen.dart';
import 'package:cardioroad/features/partners/partners_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// O widget principal que gere a barra de navegação
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // Os dados das medições são guardados aqui para poderem ser atualizados
  String _glucoseValue = "---";
  String _bloodPressureValue = "---";
  String _heartRateValue = "---";

  // Função para abrir o modal e receber o novo valor
  void _showAddMeasurementModal(MeasurementInputType type) async {
    final result = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => AddMeasurementModal(type: type),
    );

    if (result != null && result.isNotEmpty) {
      setState(() {
        switch (type) {
          case MeasurementInputType.glicemia:
            _glucoseValue = result;
            break;
          case MeasurementInputType.pressaoArterial:
            _bloodPressureValue = result;
            break;
          case MeasurementInputType.batimentosCardiacos:
            _heartRateValue = result;
            break;
        }
      });
    }
  }

  // A lista de ecrãs para a barra de navegação
  List<Widget> get _widgetOptions => <Widget>[
        HomeContent(
          glucoseValue: _glucoseValue,
          bloodPressureValue: _bloodPressureValue,
          heartRateValue: _heartRateValue,
          onAddMeasurement: _showAddMeasurementModal,
        ),
        const ServicesScreen(),
        const HistoryScreen(),
        const EmergencyScreen(),
        const SettingsScreen(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _widgetOptions,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Serviços'),
          BottomNavigationBarItem(
              icon: Icon(Icons.history), label: 'Histórico'),
          BottomNavigationBarItem(
              icon: Icon(Icons.emergency), label: 'Emergência'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ajustes'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        showUnselectedLabels: true,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

// Widget que contém apenas o conteúdo do ecrã "Início"
class HomeContent extends StatelessWidget {
  final String glucoseValue;
  final String bloodPressureValue;
  final String heartRateValue;
  final Function(MeasurementInputType) onAddMeasurement;

  const HomeContent({
    super.key,
    required this.glucoseValue,
    required this.bloodPressureValue,
    required this.heartRateValue,
    required this.onAddMeasurement,
  });

  @override
  Widget build(BuildContext context) {
    const String userName = "Nathalia";

    return Scaffold(
      appBar: AppBar(
        title: const Text('Painel de Saúde'),
        backgroundColor: AppColors.darkBackground,
        automaticallyImplyLeading: false,
      ),
      // Usamos um ListView para garantir que não haverá "overflow"
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Text(
            'Bem-vinda de volta, $userName!',
            style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.darkText),
          ),
          const SizedBox(height: 24),
          // Banner do Clube de Descontos
          _buildPartnersBanner(context),
          const SizedBox(height: 24),
          // Cards de Medição
          _buildHealthCard(
            title: 'Nível de glicemia atual',
            value: glucoseValue,
            unit: 'mg/dL',
            color: Colors.green,
            onPressed: () => onAddMeasurement(MeasurementInputType.glicemia),
          ),
          const SizedBox(height: 16),
          _buildHealthCard(
            title: 'Seu nível de pressão arterial',
            value: bloodPressureValue,
            unit: 'PA',
            color: Colors.orange,
            onPressed: () =>
                onAddMeasurement(MeasurementInputType.pressaoArterial),
          ),
          const SizedBox(height: 16),
          _buildHealthCard(
            title: 'Nível de batimentos cardíaco',
            value: heartRateValue,
            unit: 'BPM',
            color: Colors.red,
            onPressed: () =>
                onAddMeasurement(MeasurementInputType.batimentosCardiacos),
          ),
        ],
      ),
    );
  }

  // Widget para o banner do Clube de Descontos
  Widget _buildPartnersBanner(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: AppColors.primary,
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const PartnersScreen()));
        },
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: const Row(
            children: [
              Icon(FontAwesomeIcons.star, color: Colors.white, size: 32),
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

  // Widget para os cards de saúde compactos
  Widget _buildHealthCard({
    required String title,
    required String value,
    required String unit,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [color.withOpacity(0.7), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4))
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(value,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 36,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4.0),
                    child: Text(unit,
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500)),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Adicionar'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: color,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
