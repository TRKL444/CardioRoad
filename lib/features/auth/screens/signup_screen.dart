import 'package:cardioroad/features/auth/screens/login_screen.dart';
import 'package:cardioroad/shared/core/validators.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;

  final _phoneMask = MaskTextInputFormatter(
      mask: '(##) #####-####', filter: {"#": RegExp(r'[0-9]')});
  final _cpfMask = MaskTextInputFormatter(
      mask: '###.###.###-##', filter: {"#": RegExp(r'[0-9]')});

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cpfController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    FocusScope.of(context).unfocus();
    if (_formKey.currentState!.validate()) {
      // TODO: Implementar a lógica de registo com Firebase Auth aqui.
      // Ex: await FirebaseAuth.instance.createUserWithEmailAndPassword(...)

      print("Formulário de registo válido!");
      final phone = _phoneController.text.replaceAll(RegExp(r'[^\d]'), '');
      final loginCode = phone.substring(phone.length - 4);
      print("Código de acesso gerado: $loginCode");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
              'Registo realizado com sucesso! A redirecionar para o login...'),
          backgroundColor: AppColors.success,
        ),
      );

      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      });
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
            children: [
              _buildHeader(),
              _buildFormContainer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Criar Conta",
            style: TextStyle(
                color: AppColors.white,
                fontSize: 32,
                fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            'Preencha os seus dados para começar.',
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
              TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Nome Completo'),
                  validator: Validators.validateName),
              const SizedBox(height: 16),
              TextFormField(
                  controller: _emailController,
                  decoration:
                      const InputDecoration(labelText: 'Endereço de Email'),
                  keyboardType: TextInputType.emailAddress,
                  validator: Validators.validateEmail),
              const SizedBox(height: 16),
              TextFormField(
                  controller: _phoneController,
                  decoration: const InputDecoration(labelText: 'Telefone'),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [_phoneMask],
                  validator: Validators.validatePhone),
              const SizedBox(height: 16),
              TextFormField(
                  controller: _cpfController,
                  decoration: const InputDecoration(labelText: 'CPF'),
                  keyboardType: TextInputType.number,
                  inputFormatters: [_cpfMask],
                  validator: Validators.validateCpf),
              const SizedBox(height: 16),
              TextFormField(
                  controller: _cityController,
                  decoration: const InputDecoration(labelText: 'Cidade'),
                  validator: Validators.validateCity),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Palavra-passe',
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
                child: const Text('Criar Conta',
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Já tem uma conta? "),
                  GestureDetector(
                    onTap: () => Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const LoginScreen())),
                    child: const Text("Faça Login",
                        style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold)),
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
