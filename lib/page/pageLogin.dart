import 'package:flutter/material.dart';
import 'package:cardioroad/core/validators/validators.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/widgets/CustomTextFormField.dart';
import 'package:cardioroad/page/signup_screen.dart';
import 'package:cardioroad/page/telaPrincipal.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  // Controller renomeado para maior clareza
  final _loginCodeController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void dispose() {
    _loginCodeController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    // Esconde o teclado para uma melhor experiência do usuário
    FocusScope.of(context).unfocus();

    if (_formKey.currentState!.validate()) {
      // TODO: Implementar a lógica de autenticação real aqui.
      // Você vai verificar se o _loginCodeController.text e _passwordController.text
      // correspondem a um usuário válido no seu banco de dados.

      print('Formulário de login válido!');
      print('Código de Acesso: ${_loginCodeController.text}');

      // Simula um login bem-sucedido e navega para a HomeScreen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  void _navigateToSignUp() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const SignUpScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [_buildHeader(), _buildFormContainer()],
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
          // Ícone de voltar pode ser útil se essa tela for acessível de outros lugares
          // IconButton(
          //   icon: const Icon(Icons.arrow_back, color: AppColors.white, size: 28),
          //   onPressed: () => Navigator.of(context).pop(),
          //   padding: EdgeInsets.zero,
          //   constraints: const BoxConstraints(),
          // ),
          // const SizedBox(height: 20),
          Text(
            "Bem-vindo(a) de volta",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Acesse sua conta para continuar',
            style: TextStyle(color: AppColors.greyText, fontSize: 18),
          ),
        ],
      ),
    );
  }

  Widget _buildFormContainer() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.white,
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
              // Campo para o código de acesso de 4 dígitos
              CustomTextFormField(
                controller: _loginCodeController,
                labelText: 'Código de Acesso',
                hintText: 'Os 4 últimos dígitos do seu celular',
                keyboardType: TextInputType.number,
                validator: Validators.validateLoginCode,
              ),
              const SizedBox(height: 16),
              // Campo para a senha
              CustomTextFormField(
                controller: _passwordController,
                labelText: 'Senha',
                obscureText: !_isPasswordVisible,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                    color: AppColors.greyText,
                  ),
                  onPressed: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
                validator: Validators.validatePassword,
              ),
              const SizedBox(height: 16),
              _buildRememberMeAndForgotPassword(),
              const SizedBox(height: 24),
              // Botão de Entrar
              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Entrar',
                  style: TextStyle(fontSize: 18, color: AppColors.white),
                ),
              ),
              const SizedBox(height: 24),
              _buildSignUpLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) =>
                    setState(() => _rememberMe = value ?? false),
                activeColor: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'Lembrar de mim',
              style: TextStyle(color: AppColors.greyText),
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            // TODO: Implementar lógica de "Esqueceu a senha?"
          },
          child: const Text(
            'Esqueceu a senha?',
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Não tem uma conta? ",
          style: TextStyle(color: AppColors.greyText),
        ),
        GestureDetector(
          onTap: _navigateToSignUp,
          child: const Text(
            "Cadastre-se",
            style: TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}

