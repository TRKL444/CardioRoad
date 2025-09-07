import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// Importa todos os ficheiros necessários para a tela funcionar
import 'package:cardioroad/core/validators/validators.dart';
import 'package:cardioroad/shared/themes/app_colors.dart';
import 'package:cardioroad/widgets/CustomTextFormField.dart';
import 'package:cardioroad/widgets/signup_buttons.dart';
import 'package:cardioroad/widgets/signup_header.dart';
import 'package:cardioroad/widgets/signin_link.dart';
import 'package:cardioroad/widgets/terms_checkbox.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  // O estado (controllers, chaves, etc.) continua a viver na tela principal.
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _cityController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _agreeToTerms = false;

  // Formatadores de máscara para os campos de texto
  final _phoneMask = MaskTextInputFormatter(mask: '(##) #####-####');
  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##');

  @override
  void dispose() {
    // Limpa todos os controllers para evitar fugas de memória
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _cpfController.dispose();
    _cityController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Por favor, aceite os Termos e Condições.'),
          backgroundColor: AppColors.warning,
        ),
      );
      return;
    }
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Registo realizado com sucesso!'),
          backgroundColor: AppColors.success,
        ),
      );
      print('Formulário Válido!');
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
              // AGORA USAMOS OS WIDGETS QUE VOCÊ CRIOU
              const SignUpHeader(),
              Container(
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
                        CustomTextFormField(
                          controller: _nameController,
                          labelText: 'Nome Completo',
                          validator: Validators.validateName,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: _emailController,
                          labelText: 'Endereço de Email',
                          keyboardType: TextInputType.emailAddress,
                          validator: Validators.validateEmail,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: _phoneController,
                          labelText: 'Telefone',
                          keyboardType: TextInputType.phone,
                          inputFormatters: [_phoneMask],
                          validator: (value) =>
                              Validators.validatePhone(value, _phoneMask),
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: _cpfController,
                          labelText: 'CPF',
                          keyboardType: TextInputType.number,
                          inputFormatters: [_cpfMask],
                          validator: (value) =>
                              Validators.validateCpf(value, _cpfMask),
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
                          controller: _cityController,
                          labelText: 'Cidade',
                          validator: Validators.validateCity,
                        ),
                        const SizedBox(height: 16),
                        CustomTextFormField(
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
                            onPressed: () => setState(
                              () => _isPasswordVisible = !_isPasswordVisible,
                            ),
                          ),
                          validator: Validators.validatePassword,
                        ),
                        const SizedBox(height: 16),
                        TermsCheckbox(
                          value: _agreeToTerms,
                          onChanged: (value) =>
                              setState(() => _agreeToTerms = value ?? false),
                        ),
                        const SizedBox(height: 24),
                        SignUpButtons(
                          onCreateAccountPressed: _submitForm,
                          onGoogleSignUpPressed: () {
                            print('Botão Google pressionado!');
                          },
                        ),
                        const SizedBox(height: 24),
                        const SignInLink(),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
