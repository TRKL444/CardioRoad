import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
// Note: cloud_firestore e firebase_auth são mantidos para tipos, mas não usados para dados.
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';

// Definindo o Enum e o Modelo MOCK para rodar sem Firebase
enum MeasurementType { glicemia, pressaoArterial, batimentosCardiacos }

class HealthMeasurement {
  final MeasurementType type;
  final String value;
  final DateTime timestamp;

  HealthMeasurement(
      {required this.type, required this.value, required this.timestamp});
}

class HealthChart extends StatefulWidget {
  final MeasurementType type;
  // A lista de medidas agora é opcional, pois usaremos MOCK data
  final List<HealthMeasurement>? measurements;

  const HealthChart({super.key, required this.type, this.measurements});

  @override
  State<HealthChart> createState() => _HealthChartState();
}

class _HealthChartState extends State<HealthChart> {
  // --- MOCK DATA PARA GARANTIR O FUNCIONAMENTO ---
  // Criamos dados de teste baseados no tipo de medição.
  List<HealthMeasurement> _getMockMeasurements(MeasurementType type) {
    // Usamos a data atual como ponto de partida
    final now = DateTime.now();

    switch (type) {
      case MeasurementType.batimentosCardiacos:
        return [
          HealthMeasurement(
              type: type,
              value: '70',
              timestamp: now.subtract(const Duration(days: 6))),
          HealthMeasurement(
              type: type,
              value: '75',
              timestamp: now.subtract(const Duration(days: 4))),
          HealthMeasurement(
              type: type,
              value: '68',
              timestamp: now.subtract(const Duration(days: 2))),
          HealthMeasurement(type: type, value: '82', timestamp: now),
        ];
      case MeasurementType.glicemia:
        return [
          HealthMeasurement(
              type: type,
              value: '110',
              timestamp: now.subtract(const Duration(days: 5))),
          HealthMeasurement(
              type: type,
              value: '125',
              timestamp: now.subtract(const Duration(days: 3))),
          HealthMeasurement(
              type: type,
              value: '95',
              timestamp: now.subtract(const Duration(days: 1))),
          HealthMeasurement(type: type, value: '105', timestamp: now),
        ];
      case MeasurementType.pressaoArterial:
        return [
          // Valores de pressão arterial no formato string "Sistólica/Diastólica"
          HealthMeasurement(
              type: type,
              value: '120/80',
              timestamp: now.subtract(const Duration(days: 7))),
          HealthMeasurement(
              type: type,
              value: '135/85',
              timestamp: now.subtract(const Duration(days: 4))),
          HealthMeasurement(
              type: type,
              value: '115/75',
              timestamp: now.subtract(const Duration(days: 2))),
          HealthMeasurement(type: type, value: '128/82', timestamp: now),
        ];
    }
  }
  // --- FIM DO MOCK DATA ---

  @override
  Widget build(BuildContext context) {
    // 1. **IGNORAMOS O STREAMBUILDER E O FIREBASE**
    final measurements =
        widget.measurements ?? _getMockMeasurements(widget.type);

    if (measurements.length < 2) {
      return const Center(
          child: Text("Dados de teste insuficientes para exibir o gráfico."));
    }

    // 2. Lógica para configurar o gráfico (permanece a mesma)
    String unit = '';
    double maxY = 250;
    switch (widget.type) {
      case MeasurementType.glicemia:
        unit = 'mg/dL';
        maxY = 250;
        break;
      case MeasurementType.pressaoArterial:
        unit = 'mmHg';
        maxY = 200;
        break;
      case MeasurementType.batimentosCardiacos:
        unit = 'BPM';
        maxY = 150;
        break;
    }

    final List<FlSpot> spots = [];
    for (var m in measurements) {
      double? yValue;
      if (widget.type == MeasurementType.pressaoArterial) {
        // Para pressão arterial, usamos apenas o valor SISTÓLICO (o primeiro número)
        yValue = double.tryParse(m.value.toString().split('/')[0].trim());
      } else {
        yValue = double.tryParse(m.value.toString().trim());
      }

      // Converte o DateTime para um valor FlSpot (milissegundos desde a época)
      if (yValue != null) {
        spots
            .add(FlSpot(m.timestamp.millisecondsSinceEpoch.toDouble(), yValue));
      }
    }

    if (spots.length < 2) {
      return const Center(
          child: Text("Dados inválidos ou insuficientes para o gráfico."));
    }

    // Ordena os spots por data
    spots.sort((a, b) => a.x.compareTo(b.x));

    // --- O CÓDIGO DO GRÁFICO (LineChartData) é reutilizado daqui para baixo ---

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) =>
              const FlLine(color: Color(0xffe7e8ec), strokeWidth: 1),
          getDrawingVerticalLine: (value) =>
              const FlLine(color: Color(0xffe7e8ec), strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          show: true,
          rightTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles:
              const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              // Intervalo de UM DIA para os rótulos
              interval: 1000 * 60 * 60 * 24,
              getTitlesWidget: (value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return SideTitleWidget(
                  axisSide: meta.axisSide,
                  child: Text(DateFormat('dd/MM').format(date),
                      style: const TextStyle(fontSize: 10)),
                );
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                // Rótulos do eixo Y a cada 50 unidades, exceto para pressão
                if (value.toInt() % 50 == 0) {
                  return Text('${value.toInt()}',
                      style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xffe7e8ec), width: 1)),
        minX: spots.first.x,
        maxX: spots.last.x,
        minY: 0,
        maxY: maxY,
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
                show: true, color: AppColors.primary.withOpacity(0.2)),
          ),
        ],
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: AppColors.darkBackground,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final date =
                    DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                String valueText = spot.y.toInt().toString();

                // MOCK: Para pressão, buscamos o valor original mockado
                if (widget.type == MeasurementType.pressaoArterial) {
                  // Na vida real, isso seria uma busca no Firebase.
                  // Aqui, apenas simulamos o valor.
                  valueText = "${spot.y.toInt()}/${(spot.y - 40).toInt()}";
                }

                return LineTooltipItem(
                  '$valueText $unit\n',
                  const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.bold),
                  children: [
                    TextSpan(
                      text: DateFormat('dd/MM HH:mm').format(date),
                      style: TextStyle(
                          color: Colors.grey[400],
                          fontWeight: FontWeight.normal),
                    ),
                  ],
                );
              }).toList();
            },
          ),
        ),
      ),
    );
  }
}
