import 'package:cardioroad/features/auth/screens/signup_screen.dart';
import 'package:cardioroad/features/home/home_screen.dart';
import 'package:cardioroad/shared/core/validators.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _loginCodeController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  void dispose() {
    _loginCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      // TODO: Implementar a lógica de login com Firebase Auth
      print('Formulário de login válido!');
      print('Código de Acesso: ${_loginCodeController.text}');

      // Navegação para a tela principal após o login
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _navigateToSignUp() {
    // Usamos pushReplacement para evitar empilhar telas de login/registo
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeader(),
                _buildFormContainer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24.0, 60.0, 24.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Bem-vindo de volta!",
            style: TextStyle(
                color: AppColors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Faça login na sua conta',
            style: TextStyle(color: AppColors.greyText, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(40),
          topRight: Radius.circular(40),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              TextFormField(
                controller: _loginCodeController,
                decoration: const InputDecoration(
                  labelText: 'Código de Acesso',
                  hintText: 'Os 4 últimos dígitos do seu telemóvel',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: Validators.validateLoginCode,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Palavra-passe',
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: Icon(_isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onPressed: () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible),
                  ),
                ),
                obscureText: !_isPasswordVisible,
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Entrar',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Sou um novo utilizador. "),
                  GestureDetector(
                    onTap: _navigateToSignUp,
                    child: const Text(
                      "Criar Conta",
                      style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
