import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Ainda necessário para Timestamp
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cardioroad/features/history/models/health_measurement.dart';
import 'package:cardioroad/features/history/services/history_service.dart'; // Importa o nosso serviço
import 'package:cardioroad/shared/themes/app_colors.dart';

class HealthChart extends StatefulWidget {
  final MeasurementType type;

  const HealthChart(
      {super.key,
      required this.type,
      required List<HealthMeasurement> measurements});

  @override
  State<HealthChart> createState() => _HealthChartState();
}

class _HealthChartState extends State<HealthChart> {
  // Instância do nosso serviço de histórico
  final HistoryService _historyService = HistoryService();

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return const Center(child: Text('Nenhum utilizador logado'));
    }

    // Usamos um StreamBuilder para ouvir as atualizações em tempo real
    return StreamBuilder<List<HealthMeasurement>>(
      // Chamamos o método getMeasurementsStream do nosso HistoryService
      stream: _historyService.getMeasurementsStream(userId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(
              child: Text('Erro ao carregar dados: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('Nenhuma medição encontrada.'));
        }

        // Filtramos os dados recebidos pelo tipo desejado
        final measurements =
            snapshot.data!.where((m) => m.type == widget.type).toList();
        // Ordenamos por data para o gráfico
        measurements.sort((a, b) => a.timestamp.compareTo(b.timestamp));

        if (measurements.length < 2) {
          return const Center(
            child: Text(
                "São necessárias pelo menos 2 medições para exibir o gráfico."),
          );
        }

        // --- A LÓGICA DO GRÁFICO (LineChartData) continua EXATAMENTE A MESMA ---
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
            yValue = double.tryParse(m.value.toString().split('/')[0].trim());
          } else {
            yValue = double.tryParse(m.value.toString().trim());
          }
          if (yValue != null) {
            spots.add(
                FlSpot(m.timestamp.millisecondsSinceEpoch.toDouble(), yValue));
          }
        }

        if (spots.length < 2) {
          return const Center(
              child: Text("Dados inválidos ou insuficientes para o gráfico."));
        }

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
                  interval: 1000 * 60 * 60 * 24, // Um dia
                  getTitlesWidget: (value, meta) {
                    final date =
                        DateTime.fromMillisecondsSinceEpoch(value.toInt());
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
              // Alterado aqui de LineTouchTooltipData para LineTouchData
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: AppColors.darkBackground,
                getTooltipItems: (touchedSpots) {
                  return touchedSpots.map((spot) {
                    final date =
                        DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                    String valueText = spot.y.toInt().toString();
                    if (widget.type == MeasurementType.pressaoArterial) {
                      try {
                        // Adicionado try-catch para segurança
                        final originalMeasurement = measurements.firstWhere(
                          (m) =>
                              m.timestamp.millisecondsSinceEpoch ==
                              spot.x.toInt(),
                        );
                        valueText = originalMeasurement.value.toString();
                      } catch (e) {/* Ignora se não encontrar */}
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
      },
    );
  }
}
