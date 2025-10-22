import 'package:flutter/material.dart';
import 'package:cardioroad/features/auth/screens/signup_screen.dart'; // Define a tela inicial

// 1. Importações do Firebase ATIVADAS
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  // Garante que os widgets do Flutter estão prontos
  WidgetsFlutterBinding.ensureInitialized();

  // --- ALTERAÇÃO PRINCIPAL ---
  // Inicialização do Firebase ATIVADA.
  // Agora seu app está conectado ao back-end.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CardioRoad',
      debugShowCheckedModeBanner: false, // Remove a faixa de "Debug"
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color(0xFFF4F5F7),
      ),
      // A tela de registo será a primeira a ser exibida
      home: const SignUpScreen(),
    );
  }
}
