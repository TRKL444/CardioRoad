import 'package:cloud_firestore/cloud_firestore.dart';

// Enum para os tipos de medição
enum MeasurementType {
  glicemia,
  pressaoArterial,
  batimentosCardiacos,
}

// A classe agora é apenas um contentor de dados.
class HealthMeasurement {
  final String? id; // Opcional: ID do documento do Firestore
  final MeasurementType type;
  final dynamic
      value; // dynamic para aceitar '120' ou {'sistolica': 120, 'diastolica': 80}
  final DateTime timestamp;

  HealthMeasurement({
    this.id,
    required this.type,
    required this.value,
    required this.timestamp,
  });

  // Construtor de fábrica para criar um objeto a partir de dados do Firestore.
  factory HealthMeasurement.fromFirestore(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return HealthMeasurement(
      id: doc.id,
      type: MeasurementType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
        orElse: () => MeasurementType.glicemia, // Valor padrão em caso de erro
      ),
      value: data['value'],
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Método para converter o objeto para um mapa para ser salvo no Firestore.
  Map<String, dynamic> toFirestore() {
    return {
      'type': type.toString().split('.').last,
      'value': value,
      'timestamp': timestamp,
    };
  }
}
