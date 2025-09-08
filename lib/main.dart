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
        // Para usar uma fonte customizada como 'Poppins', adicione os arquivos da fonte na pasta assets/fonts,
        // e declare a fonte em pubspec.yaml conforme a documentação oficial:
        // https://docs.flutter.dev/ui/assets#declaring-fonts-in-the-pubspec-file
        fontFamily: 'Poppins',
      ),
      debugShowCheckedModeBanner: false,
      // Define a tela de cadastro como a tela inicial do aplicativo.
      home: const SignUpScreen(),
    );
  }
}
