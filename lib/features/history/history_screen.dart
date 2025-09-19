import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/features/history/models/glucose_measurement.dart';
import 'package:cardioroad/features/history/widgets/glucose_chart.dart';
import 'package:cardioroad/features/history/widgets/measurement_list_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // A lista de dados de exemplo continua aqui por enquanto.
  final List<GlucoseMeasurement> measurements = [
    GlucoseMeasurement(value: 110, timestamp: DateTime.parse("2025-09-10 08:30:00")),
    GlucoseMeasurement(value: 150, timestamp: DateTime.parse("2025-09-11 09:45:00")),
    GlucoseMeasurement(value: 95, timestamp: DateTime.parse("2025-09-12 08:15:00")),
    GlucoseMeasurement(value: 180, timestamp: DateTime.parse("2025-09-13 12:10:00")),
    GlucoseMeasurement(value: 120, timestamp: DateTime.parse("2025-09-14 20:00:00")),
    GlucoseMeasurement(value: 135, timestamp: DateTime.parse("2025-09-15 08:00:00")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Glicemia'),
        backgroundColor: AppColors.darkBackground,
        iconTheme: const IconThemeData(color: Colors.white),
        titleTextStyle: const TextStyle(
          color: Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: AppColors.lightGreyBackground,
      body: Column(
        children: [
          // CARD DO GRÁFICO
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                     Text(
                      'Evolução Semanal',
                      style: TextStyle(
                        color: AppColors.darkText,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    // Usamos o nosso widget de gráfico customizado
                    SizedBox(height: 200, child: GlucoseChart(measurements: measurements)),
                  ],
                ),
              ),
            ),
          ),
          // LISTA DE MEDIÇÕES
           Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Todas as Medições',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.darkText),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: measurements.length,
              itemBuilder: (context, index) {
                final measurement = measurements.reversed.toList()[index];
                // Usamos o nosso widget de item da lista customizado
                return MeasurementListTile(measurement: measurement);
              },
            ),
          ),
        ],
      ),
    );
  }
}

