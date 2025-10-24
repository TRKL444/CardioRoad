import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';

// Importa as classes de modelo que definimos temporariamente no health_chart.dart
// NOTE: Você precisa garantir que estas classes sejam acessíveis neste arquivo!
// Se estiverem em um arquivo de modelos, use o import correto.
import 'package:cardioroad/features/history/widgets/health_chart.dart';
import 'package:intl/intl.dart';

// Assumindo que você tem um widget para cada item da lista (MeasurementListTile)
// Se este widget estiver faltando, crie um placeholder simples.
class MeasurementListTile extends StatelessWidget {
  final HealthMeasurement measurement;
  const MeasurementListTile({super.key, required this.measurement});

  String get typeString {
    switch (measurement.type) {
      case MeasurementType.glicemia:
        return 'Glicemia';
      case MeasurementType.pressaoArterial:
        return 'Pressão Arterial';
      case MeasurementType.batimentosCardiacos:
        return 'Batimentos Cardíacos';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.favorite, color: AppColors.primary),
      title: Text(typeString),
      subtitle: Text(
          'Valor: ${measurement.value} | Data: ${DateFormat('dd/MM HH:mm').format(measurement.timestamp)}'),
    );
  }
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Lista de tipos de medição que você quer carregar
  final List<MeasurementType> _measurementTypes = [
    MeasurementType.batimentosCardiacos,
    MeasurementType.glicemia,
    MeasurementType.pressaoArterial,
  ];

  // O tipo de medição atualmente selecionado (o primeiro por padrão)
  MeasurementType _selectedType = MeasurementType.batimentosCardiacos;

  late Future<List<HealthMeasurement>> _mockDataFuture;

  @override
  void initState() {
    super.initState();
    // Inicia o carregamento dos dados de teste na inicialização da tela
    _mockDataFuture = _loadMockData();
  }

  // --- FUNÇÃO DE SIMULAÇÃO DE CARREGAMENTO (SUBSTITUI O FIRESTORE) ---
  Future<List<HealthMeasurement>> _loadMockData() async {
    // Simula um delay de rede
    await Future.delayed(const Duration(seconds: 1));
    final now = DateTime.now();

    // Dados de teste unificados (para simular a coleção do Firestore)
    final List<HealthMeasurement> allMockData = [
      // Batimentos Cardíacos
      HealthMeasurement(
          type: MeasurementType.batimentosCardiacos,
          value: '70',
          timestamp: now.subtract(const Duration(hours: 48))),
      HealthMeasurement(
          type: MeasurementType.batimentosCardiacos,
          value: '85',
          timestamp: now.subtract(const Duration(hours: 12))),
      // Glicemia
      HealthMeasurement(
          type: MeasurementType.glicemia,
          value: '110',
          timestamp: now.subtract(const Duration(hours: 72))),
      HealthMeasurement(
          type: MeasurementType.glicemia,
          value: '125',
          timestamp: now.subtract(const Duration(hours: 24))),
      // Pressão Arterial
      HealthMeasurement(
          type: MeasurementType.pressaoArterial,
          value: '120/80',
          timestamp: now.subtract(const Duration(hours: 96))),
      HealthMeasurement(
          type: MeasurementType.pressaoArterial,
          value: '135/85',
          timestamp: now.subtract(const Duration(hours: 6))),
    ];

    return allMockData;
  }
  // --- FIM DA SIMULAÇÃO ---

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Saúde'),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<HealthMeasurement>>(
        // Usa a função de dados de teste (mock)
        future: _mockDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          // O erro de Firestore não ocorrerá, mas tratamos erros gerais
          if (snapshot.hasError) {
            return Center(
                child: Text('Erro de carregamento (MOCK): ${snapshot.error}'));
          }

          final allMeasurements = snapshot.data ?? [];

          // 1. FILTRA os dados para o tipo selecionado
          final filteredMeasurements =
              allMeasurements.where((m) => m.type == _selectedType).toList();

          // 2. ORDENA pela data (o mais recente primeiro)
          filteredMeasurements
              .sort((a, b) => b.timestamp.compareTo(a.timestamp));

          return Column(
            children: [
              // ------------------------------------
              // SELEÇÃO DE TIPO DE MEDIÇÃO
              // ------------------------------------
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: DropdownButtonFormField<MeasurementType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    labelText: 'Selecione o Tipo de Medição',
                    border: OutlineInputBorder(),
                  ),
                  items: _measurementTypes.map((MeasurementType type) {
                    return DropdownMenuItem<MeasurementType>(
                      value: type,
                      child: Text(type.toString().split('.').last),
                    );
                  }).toList(),
                  onChanged: (MeasurementType? newValue) {
                    if (newValue != null) {
                      setState(() {
                        _selectedType = newValue;
                      });
                    }
                  },
                ),
              ),

              // ------------------------------------
              // GRÁFICO (USA O HealthChart)
              // ------------------------------------
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 20, 20, 10),
                    // Passa a lista de dados filtrada para o widget de gráfico
                    child: SizedBox(
                      height: 250,
                      child: HealthChart(
                        type: _selectedType,
                        measurements:
                            filteredMeasurements, // Passando dados de MOCK
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // ------------------------------------
              // LISTA DE MEDIÇÕES
              // ------------------------------------
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Registros Recentes:',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              if (filteredMeasurements.isEmpty)
                Center(
                    child: Text('Nenhuma medição encontrada para este tipo.')),

              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filteredMeasurements.length,
                  itemBuilder: (context, index) {
                    // Nota: Os dados já estão ordenados de forma decrescente acima,
                    // então não precisamos do .reversed.toList()
                    final measurement = filteredMeasurements[index];

                    // O erro de tipo da sua imagem FOI RESOLVIDO, pois o widget
                    // MeasurementListTile e o filteredMeasurements[index]
                    // agora compartilham a mesma classe HealthMeasurement
                    // definida no health_chart.dart.
                    return MeasurementListTile(measurement: measurement);
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
