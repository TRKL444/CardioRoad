import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';

// Modelo de dados simples para uma medição de glicemia
class GlucoseMeasurement {
  final int value;
  final DateTime timestamp;

  // O construtor permanece o mesmo
  GlucoseMeasurement({required this.value, required this.timestamp});
}

class HistoryScreen extends StatelessWidget {
  // REMOVIDO 'const' do construtor
  HistoryScreen({super.key});

  // Lista de dados de exemplo (mock) para demonstração
  // CORRIGIDO: Usamos DateTime.parse() para converter a String em DateTime
  final List<GlucoseMeasurement> measurements = [
    GlucoseMeasurement(
      value: 110,
      timestamp: DateTime.parse("2025-09-10 08:30:00"),
    ),
    GlucoseMeasurement(
      value: 150,
      timestamp: DateTime.parse("2025-09-09 19:45:00"),
    ),
    GlucoseMeasurement(
      value: 95,
      timestamp: DateTime.parse("2025-09-09 08:15:00"),
    ),
    GlucoseMeasurement(
      value: 180,
      timestamp: DateTime.parse("2025-09-08 12:10:00"),
    ),
    GlucoseMeasurement(
      value: 120,
      timestamp: DateTime.parse("2025-09-07 20:00:00"),
    ),
  ];

  // Função para determinar a cor com base no valor da glicemia
  Color _getColorForValue(int value) {
    if (value > 140) return Colors.red.shade400; // Nível alto
    if (value < 70) return Colors.orange.shade400; // Nível baixo
    return Colors.green.shade500; // Nível normal
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Medições'),
        backgroundColor: AppColors.darkBackground,
        iconTheme: const IconThemeData(color: AppColors.white),
        titleTextStyle: const TextStyle(
          color: AppColors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: ListView.builder(
        itemCount: measurements.length,
        itemBuilder: (context, index) {
          final measurement = measurements[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              leading: CircleAvatar(
                backgroundColor: _getColorForValue(measurement.value),
                child: const Icon(Icons.opacity, color: Colors.white),
              ),
              title: Text(
                '${measurement.value} mg/dL',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              subtitle: Text(
                // Formatando a data e hora para exibição
                '${measurement.timestamp.day.toString().padLeft(2, '0')}/${measurement.timestamp.month.toString().padLeft(2, '0')}/${measurement.timestamp.year} às ${measurement.timestamp.hour}:${measurement.timestamp.minute.toString().padLeft(2, '0')}',
              ),
            ),
          );
        },
      ),
    );
  }
}
