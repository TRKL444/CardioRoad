import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cardioroad/features/history/models/glucose_measurement.dart';

class MeasurementListTile extends StatelessWidget {
  final GlucoseMeasurement measurement;

  const MeasurementListTile({super.key, required this.measurement});

  Color _getColorForValue(int value) {
    if (value < 70) return Colors.blue;
    if (value > 180) return Colors.red;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context) {
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
        trailing: Text('mg/dL', style: TextStyle(color: Colors.grey[600])),
      ),
    );
  }
}
