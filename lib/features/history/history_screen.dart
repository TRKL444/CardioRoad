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
  final List<GlucoseMeasurement> measurements = [
    GlucoseMeasurement(
        value: 110, timestamp: DateTime.parse("2025-09-10 08:30:00")),
    GlucoseMeasurement(
        value: 150, timestamp: DateTime.parse("2025-09-11 09:45:00")),
    GlucoseMeasurement(
        value: 95, timestamp: DateTime.parse("2025-09-12 08:15:00")),
    GlucoseMeasurement(
        value: 180, timestamp: DateTime.parse("2025-09-13 12:10:00")),
    GlucoseMeasurement(
        value: 120, timestamp: DateTime.parse("2025-09-14 20:00:00")),
    GlucoseMeasurement(
        value: 135, timestamp: DateTime.parse("2025-09-15 08:00:00")),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Glicemia'),
        backgroundColor: AppColors.darkBackground,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Evolução Semanal',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 24),
                    SizedBox(
                        height: 200,
                        child: GlucoseChart(measurements: measurements)),
                  ],
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('Todas as Medições',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: measurements.length,
              itemBuilder: (context, index) {
                final measurement = measurements.reversed.toList()[index];
                return MeasurementListTile(measurement: measurement);
              },
            ),
          ),
        ],
      ),
    );
  }
}
