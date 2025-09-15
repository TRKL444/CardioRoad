import 'package:flutter/material.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:fl_chart/fl_chart.dart'; // Importa o pacote de gráficos
import 'package:intl/intl.dart';       // Importa o pacote de formatação de data

// Modelo de dados simples para uma medição de glicemia
class GlucoseMeasurement {
  final int value;
  final DateTime timestamp;

  GlucoseMeasurement({required this.value, required this.timestamp});
}

class HistoryScreen extends StatefulWidget {
  // Tornamos o widget Stateful para lidar com a interatividade do gráfico
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  // Lista de dados de exemplo (mock) para demonstração
  final List<GlucoseMeasurement> measurements = [
    GlucoseMeasurement(value: 110, timestamp: DateTime.parse("2025-09-10 08:30:00")),
    GlucoseMeasurement(value: 150, timestamp: DateTime.parse("2025-09-11 09:45:00")),
    GlucoseMeasurement(value: 95, timestamp: DateTime.parse("2025-09-12 08:15:00")),
    GlucoseMeasurement(value: 180, timestamp: DateTime.parse("2025-09-13 12:10:00")),
    GlucoseMeasurement(value: 120, timestamp: DateTime.parse("2025-09-14 20:00:00")),
    GlucoseMeasurement(value: 135, timestamp: DateTime.parse("2025-09-15 08:00:00")),
  ];

  // Função para determinar a cor com base no valor da glicemia
  Color _getColorForValue(int value) {
    if (value < 70) return Colors.blue; // Hipoglicemia
    if (value > 180) return Colors.red; // Hiperglicemia
    return Colors.green; // Normal
  }

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
                    SizedBox(
                      height: 200,
                      child: LineChart(_buildChartData()),
                    ),
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
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.darkText,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: measurements.length,
              itemBuilder: (context, index) {
                // Ordena a lista da mais recente para a mais antiga
                final measurement = measurements.reversed.toList()[index];
                final formattedDate = DateFormat('dd/MM/yyyy').format(measurement.timestamp);
                final formattedTime = DateFormat('HH:mm').format(measurement.timestamp);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                    leading: CircleAvatar(
                      backgroundColor: _getColorForValue(measurement.value).withOpacity(0.15),
                      child: Text(
                        measurement.value.toString(),
                        style: TextStyle(
                          color: _getColorForValue(measurement.value),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: const Text('Glicemia', style: TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text('$formattedDate às $formattedTime'),
                    trailing: Text(
                      'mg/dL',
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Função que constrói e estiliza o gráfico
  LineChartData _buildChartData() {
    // Converte os nossos dados para o formato que o gráfico entende
    final spots = measurements.map((m) {
      return FlSpot(m.timestamp.millisecondsSinceEpoch.toDouble(), m.value.toDouble());
    }).toList();

    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        getDrawingHorizontalLine: (value) {
          return const FlLine(color: Color(0xffe7e8ec), strokeWidth: 1);
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(color: Color(0xffe7e8ec), strokeWidth: 1);
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1000 * 60 * 60 * 24, // Um dia de intervalo
            getTitlesWidget: (value, meta) {
              final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
              return SideTitleWidget(
                axisSide: meta.axisSide,
                child: Text(DateFormat('dd/MM').format(date), style: const TextStyle(fontSize: 10)),
              );
            },
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              // Mostra os títulos do eixo Y de 50 em 50
              if (value.toInt() % 50 == 0) {
                return Text('${value.toInt()}', style: const TextStyle(fontSize: 10));
              }
              return const Text('');
            },
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xffe7e8ec), width: 1),
      ),
      minX: spots.first.x,
      maxX: spots.last.x,
      minY: 0,
      maxY: 250, // Define um valor máximo para o eixo Y
      lineBarsData: [
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: AppColors.primary,
          barWidth: 4,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: true), // Mostra os pontos no gráfico
          belowBarData: BarAreaData(
            show: true,
            color: AppColors.primary.withOpacity(0.2),
          ),
        ),
      ],
      // Configuração da dica que aparece ao tocar no gráfico
      lineTouchData: LineTouchData(
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: AppColors.darkBackground,
          getTooltipItems: (touchedSpots) {
            return touchedSpots.map((spot) {
              final date = DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
              return LineTooltipItem(
                '${spot.y.toInt()} mg/dL\n',
                const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                children: [
                  TextSpan(
                    text: DateFormat('dd/MM HH:mm').format(date),
                    style: TextStyle(
                      color: Colors.grey[400],
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                ],
              );
            }).toList();
          },
        ),
      ),
    );
  }
}

