// Modelo de dados simples para uma medição de glicemia.
// Ter um arquivo separado para o modelo ajuda a manter o código organizado.
class GlucoseMeasurement {
  final int value;
  final DateTime timestamp;

  GlucoseMeasurement({required this.value, required this.timestamp});
}
