import 'package:flutter/material.dart';
// Importa o nosso arquivo de cores. Lembre-se de criar este arquivo também.
import 'package:cardioroad/shared/themes/app_colors.dart';

// A tela de cadastro é um StatefulWidget para gerir o seu próprio estado,
// como a visibilidade da palavra-passe e o estado da checkbox.
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // Chave global para identificar e validar o formulário.
  final _formKey = GlobalKey<FormState>();

  // Controladores para aceder ao conteúdo dos campos de texto.
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();

  // Variáveis para controlar o estado da UI.
  bool _isPasswordVisible = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    // Limpar os controladores é crucial para libertar memória.
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cpfController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Função chamada ao pressionar o botão "Criar Conta".
  void _submitForm() {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa de aceitar os Termos e Condições.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }

    if (_formKey.currentState!.validate()) {
      print('Formulário válido! A registar utilizador...');
      print('Nome: ${_nameController.text}');
      print('Email: ${_emailController.text}');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registo realizado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
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

  // --- Widgets Refatorados para Melhor Legibilidade ---

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ícone de voltar (pode adicionar a funcionalidade depois)
          const Icon(Icons.arrow_back, color: AppColors.white, size: 28),
          const SizedBox(height: 20),
          const Text(
            "Let's Start",
            style: TextStyle(
              color: AppColors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Create an account',
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
              _buildTextFormField(
                controller: _nameController,
                labelText: 'Nome Completo',
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Por favor, insira o seu nome completo.';
                  if (value.trim().split(' ').length < 2)
                    return 'Por favor, insira nome e apelido.';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _emailController,
                labelText: 'Endereço de Email',
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty)
                    return 'Por favor, insira o seu email.';
                  if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
                    return 'Por favor, insira um email válido.';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _phoneController,
                labelText: 'Telefone',
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, insira o seu telefone.'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _cpfController,
                labelText: 'CPF',
                keyboardType: TextInputType.number,
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, insira o seu CPF.'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _cityController,
                labelText: 'Cidade',
                validator: (value) => value == null || value.isEmpty
                    ? 'Por favor, insira a sua cidade.'
                    : null,
              ),
              const SizedBox(height: 16),
              _buildTextFormField(
                controller: _passwordController,
                labelText: 'Palavra-passe',
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
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'Por favor, insira a sua palavra-passe.';
                  if (value.length < 6)
                    return 'A palavra-passe deve ter no mínimo 6 caracteres.';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildTermsCheckbox(),
              const SizedBox(height: 24),
              _buildSubmitButtons(),
              const SizedBox(height: 24),
              _buildSignInLink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    Widget? suffixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.greyText),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: AppColors.textFieldFill,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: validator,
    );
  }

  Widget _buildTermsCheckbox() {
    return CheckboxListTile(
      value: _agreeToTerms,
      onChanged: (value) => setState(() => _agreeToTerms = value ?? false),
      title: const Text(
        'Eu aceito os Termos & Condições e a Política de Privacidade',
        style: TextStyle(fontSize: 14, color: AppColors.greyText),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      contentPadding: EdgeInsets.zero,
      activeColor: AppColors.primary,
    );
  }

  Widget _buildSubmitButtons() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
            'Criar Conta',
            style: TextStyle(fontSize: 18, color: AppColors.white),
          ),
        ),
        const SizedBox(height: 16),
        OutlinedButton.icon(
          onPressed: () {
            /* TODO: Implementar login com Google */
          },
          icon: Icon(
            Icons.g_mobiledata_outlined,
            color: Colors.red,
          ), // Ícone placeholder
          label: const Text(
            'Registar com Google',
            style: TextStyle(color: Colors.black54),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            side: const BorderSide(color: AppColors.greyText),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Já tem uma conta? ",
          style: TextStyle(color: AppColors.greyText),
        ),
        GestureDetector(
          onTap: () {
            /* TODO: Navegar para a tela de login */
          },
          child: const Text(
            "Entrar",
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
