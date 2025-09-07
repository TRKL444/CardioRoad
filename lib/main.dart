import 'package:flutter/material.dart';
// Importa a tela de cadastro que vamos criar.
import 'package:cardioroad/page/signup_screen.dart';

// Função principal que inicia o aplicativo.
void main() {
  runApp(const MyApp());
}

// Widget raiz do aplicativo.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardioRoad',
      theme: ThemeData(
        // Define uma fonte global para o app para um visual mais consistente.
        // Lembre-se de adicionar a fonte no seu pubspec.yaml se for uma customizada.
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      // Define a tela de cadastro como a tela inicial do aplicativo.
      home: const SignUpScreen(),
    );
  }
}
