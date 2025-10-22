import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cardioroad/features/history/models/health_measurement.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';

class MeasurementListTile extends StatelessWidget {
  final HealthMeasurement measurement;

  const MeasurementListTile({super.key, required this.measurement});

  @override
  Widget build(BuildContext context) {
    final formattedDate =
        DateFormat('dd/MM/yyyy').format(measurement.timestamp);
    final formattedTime = DateFormat('HH:mm').format(measurement.timestamp);

    String title = '';
    String unit = '';
    IconData icon;
    Color color;

    // Adapta a UI com base no tipo de medição
    switch (measurement.type) {
      case MeasurementType.glicemia:
        title = 'Glicemia';
        unit = 'mg/dL';
        icon = Icons.bloodtype;
        color = _getColorForGlucose(int.tryParse(measurement.value) ?? 0);
        break;
      case MeasurementType.pressaoArterial:
        title = 'Pressão Arterial';
        unit = 'mmHg';
        icon = Icons.favorite_border;
        color = AppColors.primary;
        break;
      case MeasurementType.batimentosCardiacos:
        title = 'Batimentos Cardíacos';
        unit = 'BPM';
        icon = Icons.monitor_heart_outlined;
        color = AppColors.primary;
        break;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$formattedDate às $formattedTime'),
        trailing: Text(
          '${measurement.value} $unit',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: AppColors.darkText),
        ),
      ),
    );
  }

  // Função específica para as cores da glicemia
  Color _getColorForGlucose(int value) {
    if (value < 70) return Colors.blue;
    if (value > 180) return Colors.red;
    return Colors.green;
  }
}
