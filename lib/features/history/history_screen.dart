import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/features/history/models/health_measurement.dart';
import 'package:cardioroad/features/history/widgets/health_chart.dart';
import 'package:cardioroad/features/history/widgets/measurement_list_tile.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Lista de dados de exemplo com diferentes tipos de medição
  final List<HealthMeasurement> allMeasurements = [
    HealthMeasurement(
        type: MeasurementType.glicemia,
        value: '110',
        timestamp: DateTime.parse("2025-09-10 08:30:00")),
    HealthMeasurement(
        type: MeasurementType.pressaoArterial,
        value: '120/80',
        timestamp: DateTime.parse("2025-09-10 09:00:00")),
    HealthMeasurement(
        type: MeasurementType.glicemia,
        value: '150',
        timestamp: DateTime.parse("2025-09-11 09:45:00")),
    HealthMeasurement(
        type: MeasurementType.batimentosCardiacos,
        value: '75',
        timestamp: DateTime.parse("2025-09-11 10:00:00")),
    HealthMeasurement(
        type: MeasurementType.glicemia,
        value: '95',
        timestamp: DateTime.parse("2025-09-12 08:15:00")),
    HealthMeasurement(
        type: MeasurementType.pressaoArterial,
        value: '125/85',
        timestamp: DateTime.parse("2025-09-12 09:15:00")),
    HealthMeasurement(
        type: MeasurementType.batimentosCardiacos,
        value: '80',
        timestamp: DateTime.parse("2025-09-12 10:00:00")),
    HealthMeasurement(
        type: MeasurementType.glicemia,
        value: '180',
        timestamp: DateTime.parse("2025-09-13 12:10:00")),
  ];

  MeasurementType _selectedFilter = MeasurementType.glicemia;

  @override
  Widget build(BuildContext context) {
    // Filtra a lista com base no tipo selecionado
    final filteredMeasurements =
        allMeasurements.where((m) => m.type == _selectedFilter).toList();
    // Ordena os dados por data para o gráfico funcionar corretamente
    filteredMeasurements.sort((a, b) => a.timestamp.compareTo(b.timestamp));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Saúde'),
        backgroundColor: AppColors.darkBackground,
        automaticallyImplyLeading: false, // Remove a seta de "voltar"
      ),
      body: Column(
        children: [
          // Botões de Filtro
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SegmentedButton<MeasurementType>(
              style: SegmentedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                selectedForegroundColor: Colors.white,
                selectedBackgroundColor: AppColors.primary,
              ),
              segments: const <ButtonSegment<MeasurementType>>[
                ButtonSegment(
                    value: MeasurementType.glicemia,
                    label: Text('Glicemia'),
                    icon: Icon(Icons.bloodtype)),
                ButtonSegment(
                    value: MeasurementType.pressaoArterial,
                    label: Text('Pressão')),
                ButtonSegment(
                    value: MeasurementType.batimentosCardiacos,
                    label: Text('Batimentos')),
              ],
              selected: {_selectedFilter},
              onSelectionChanged: (Set<MeasurementType> newSelection) {
                setState(() {
                  _selectedFilter = newSelection.first;
                });
              },
            ),
          ),
          // Card que contém o Gráfico
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  height: 200,
                  // Usamos o nosso novo widget de gráfico genérico, passando os dados filtrados
                  child: HealthChart(
                    measurements: filteredMeasurements,
                    type: _selectedFilter,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Todas as Medições',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.darkText),
              ),
            ),
          ),
          // Lista de medições filtradas
          Expanded(
            child: filteredMeasurements.isEmpty
                ? const Center(
                    child: Text('Nenhuma medição encontrada para este tipo.'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredMeasurements.length,
                    itemBuilder: (context, index) {
                      final measurement =
                          filteredMeasurements.reversed.toList()[index];
                      return MeasurementListTile(measurement: measurement);
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
