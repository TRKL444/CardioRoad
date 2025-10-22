import 'package:cloud_firestore/cloud_firestore.dart';

enum MeasurementType { glicemia, pressaoArterial, batimentosCardiacos }

class HealthMeasurement {
  final MeasurementType type;
  final dynamic value; // Alterado para dynamic para acomodar String ou Map
  final DateTime timestamp;
  final String? id; // Adicionado para armazenar o ID do documento Firestore

  HealthMeasurement({
    required this.type,
    required this.value,
    required this.timestamp,
    this.id,
  });

  // Converte o objeto para um mapa para salvar no Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'type': type.toString().split('.').last, // Armazena apenas o nome do enum
      'value': value,
      'timestamp': timestamp,
    };
  }

  // Cria um HealthMeasurement a partir de um documento Firestore
  factory HealthMeasurement.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return HealthMeasurement(
      id: doc.id,
      type: MeasurementType.values.firstWhere(
        (e) => e.toString().split('.').last == data['type'],
      ),
      value: data['value'], // Não é mais um cast direto para String
      timestamp: (data['timestamp'] as Timestamp).toDate(),
    );
  }

  // Método para salvar no Firestore
  Future<void> saveToFirestore(String userId) async {
    final firestore = FirebaseFirestore.instance;
    try {
      final docRef = firestore
          .collection('users')
          .doc(userId)
          .collection('health_measurements')
          .doc(
            id ??
                firestore
                    .collection('users')
                    .doc(userId)
                    .collection('health_measurements')
                    .doc()
                    .id,
          ); // Simplificado a geração de ID

      await docRef.set(toFirestore());
    } catch (e) {
      print('Erro ao salvar medição no Firestore: $e');
      rethrow; // Relança o erro para ser tratado em um nível superior
    }
  }

  // Método para buscar todas as medições de um usuário
  static Future<List<HealthMeasurement>> getAllForUser(String userId) async {
    final firestore = FirebaseFirestore.instance;
    try {
      final snapshot = await firestore
          .collection('users')
          .doc(userId)
          .collection('health_measurements')
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs
          .map((doc) => HealthMeasurement.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Erro ao buscar medições no Firestore: $e');
      rethrow;
    }
  }

  // Método para deletar uma medição
  Future<void> deleteFromFirestore(String userId) async {
    if (id == null) return;
    final firestore = FirebaseFirestore.instance;
    try {
      await firestore
          .collection('users')
          .doc(userId)
          .collection('health_measurements')
          .doc(id)
          .delete();
    } catch (e) {
      print('Erro ao deletar medição no Firestore: $e');
      rethrow;
    }
  }
}

// Exemplo de uso para pressão arterial com Map
/*
HealthMeasurement pressaoArterial = HealthMeasurement(
  type: MeasurementType.pressaoArterial,
  value: {'sistolica': 120, 'diastolica': 80},
  timestamp: DateTime.now(),
);
*/
