import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cardioroad/features/history/models/glucose_measurement.dart';

class MeasurementListTile extends StatelessWidget {
  final GlucoseMeasurement measurement;

  const MeasurementListTile({super.key, required this.measurement});

  // Função para determinar a cor com base no valor da glicemia
  Color _getColorForValue(int value) {
    if (value < 70) {
      return Colors.blue; // Hipoglicemia
    }
    if (value > 180) {
      return Colors.red; // Hiperglicemia
    }
    return Colors.green; // Normal
  }

  @override
  Widget build(BuildContext context) {
    // Formata a data e a hora para uma apresentação amigável
    final formattedDate =
        DateFormat('dd/MM/yyyy').format(measurement.timestamp);
    final formattedTime = DateFormat('HH:mm').format(measurement.timestamp);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        // Círculo à esquerda com o valor da medição
        leading: CircleAvatar(
          backgroundColor:
              _getColorForValue(measurement.value).withOpacity(0.15),
          child: Text(
            measurement.value.toString(),
            style: TextStyle(
              color: _getColorForValue(measurement.value),
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        // Título e subtítulo (data e hora)
        title: const Text('Glicemia',
            style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text('$formattedDate às $formattedTime'),
        // Texto "mg/dL" no final
        trailing: Text(
          'mg/dL',
          style: TextStyle(color: Colors.grey[600]),
        ),
      ),
    );
  }
}
