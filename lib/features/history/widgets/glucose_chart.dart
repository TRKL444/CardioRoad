import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:cardioroad/features/history/models/glucose_measurement.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';

class GlucoseChart extends StatelessWidget {
  final List<GlucoseMeasurement> measurements;

  const GlucoseChart({super.key, required this.measurements});

  @override
  Widget build(BuildContext context) {
    // Se não houver medições, exibe uma mensagem.
    if (measurements.isEmpty) {
      return const Center(
        child: Text("Não há dados suficientes para exibir o gráfico."),
      );
    }

    // Converte a nossa lista de medições para o formato de pontos (FlSpot) que o gráfico entende.
    final spots = measurements.map((m) {
      return FlSpot(
          m.timestamp.millisecondsSinceEpoch.toDouble(), m.value.toDouble());
    }).toList();

    return LineChart(
      LineChartData(
        // Configuração da grelha de fundo
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) =>
              const FlLine(color: Color(0xffe7e8ec), strokeWidth: 1),
          getDrawingVerticalLine: (value) =>
              const FlLine(color: Color(0xffe7e8ec), strokeWidth: 1),
        ),
        // Configuração dos títulos dos eixos (X e Y)
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
              interval:
                  1000 * 60 * 60 * 24, // Um dia de intervalo entre os títulos
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
                if (value.toInt() % 50 == 0) {
                  // Mostra os valores de 50 em 50
                  return Text('${value.toInt()}',
                      style: const TextStyle(fontSize: 10));
                }
                return const Text('');
              },
            ),
          ),
        ),
        // Configuração da borda do gráfico
        borderData: FlBorderData(
            show: true,
            border: Border.all(color: const Color(0xffe7e8ec), width: 1)),
        // Define os limites dos eixos
        minX: spots.first.x,
        maxX: spots.last.x,
        minY: 0,
        maxY: 250, // Um valor máximo razoável para glicemia
        // Configuração da linha do gráfico
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            color: AppColors.primary,
            barWidth: 4,
            isStrokeCapRound: true,
            dotData: const FlDotData(show: true), // Mostra os pontos no gráfico
            belowBarData: BarAreaData(
                show: true, color: AppColors.primary.withOpacity(0.2)),
          ),
        ],
        // Configuração da dica (tooltip) que aparece ao tocar num ponto
        lineTouchData: LineTouchData(
          touchTooltipData: LineTouchTooltipData(
            tooltipBgColor: AppColors.darkBackground,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                final date =
                    DateTime.fromMillisecondsSinceEpoch(spot.x.toInt());
                return LineTooltipItem(
                  '${spot.y.toInt()} mg/dL\n',
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
