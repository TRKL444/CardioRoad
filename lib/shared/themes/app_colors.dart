import 'package:flutter/material.dart';

// Classe para armazenar todas as cores padrão da aplicação.
// Utilizar uma classe de cores centralizada facilita a manutenção do design.
class AppColors {
  // Construtor privado para evitar que a classe seja instanciada.
  AppColors._();

  // Cores baseadas no template de design que escolheu.
  static const Color darkBackground = Color(0xFF1C1C2D);
  static const Color primary = Color(
    0xFF2E2E48,
  ); // Azul escuro dos botões/elementos
  static const Color white = Colors.white;
  static const Color greyText = Colors.grey;
  static const Color textFieldFill = Color(0xFFF7F7F7);
  static const Color error = Colors.redAccent;
  static const Color success = Colors.green;
  static const Color warning = Colors.orangeAccent;

  static Color? darkText;

  static Color? get lightGreyBackground => null;
}
