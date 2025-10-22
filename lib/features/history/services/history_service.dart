import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cardioroad/features/history/models/health_measurement.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Função auxiliar para obter a referência à sub-coleção correta no Firestore
  CollectionReference<Map<String, dynamic>> _getMeasurementsCollection(
      String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('health_measurements');
  }

  // --- MÉTODOS PARA INTERAGIR COM O FIREBASE ---

  /// Adiciona uma nova medição de saúde para o utilizador especificado.
  Future<void> addMeasurement(
      String userId, HealthMeasurement measurement) async {
    try {
      // Usa o método `add` para criar um novo documento com ID automático
      // e o método `toFirestore()` do nosso modelo para converter os dados.
      await _getMeasurementsCollection(userId).add(measurement.toFirestore());
      print("Medição adicionada com sucesso ao Firebase.");
    } catch (e) {
      print('Erro ao adicionar medição ao Firebase: $e');
      // Relançar o erro permite que a UI (a tela que chamou este método)
      // possa mostrar uma mensagem de erro para o utilizador.
      rethrow;
    }
  }

  /// Retorna um Stream (fluxo contínuo) com a lista de medições de saúde
  /// do utilizador especificado, ordenadas da mais recente para a mais antiga.
  /// O StreamBuilder na UI irá ouvir este fluxo e atualizar-se automaticamente
  /// sempre que houver uma alteração na base de dados.
  Stream<List<HealthMeasurement>> getMeasurementsStream(String userId) {
    return _getMeasurementsCollection(userId)
        .orderBy('timestamp',
            descending: true) // Ordena pela data, mais recentes primeiro
        .snapshots() // Ouve as alterações em tempo real
        .map((snapshot) {
      // Para cada "foto" da coleção...
      // Converte cada documento do Firestore num objeto HealthMeasurement
      return snapshot.docs
          .map((doc) => HealthMeasurement.fromFirestore(doc))
          .toList();
    });
  }

  /// Apaga uma medição de saúde específica do Firestore.
  Future<void> deleteMeasurement(String userId, String measurementId) async {
    try {
      await _getMeasurementsCollection(userId).doc(measurementId).delete();
      print("Medição apagada com sucesso do Firebase.");
    } catch (e) {
      print('Erro ao apagar medição do Firebase: $e');
      rethrow;
    }
  }
}
