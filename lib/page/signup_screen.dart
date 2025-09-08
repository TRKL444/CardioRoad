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
      // 1. Pega o número de telefone do controller.
      final String phoneNumber = _phoneController.text;

      // 2. Remove a máscara para obter apenas os números.
      final String unmaskedPhone = phoneNumber.replaceAll(RegExp(r'[^\d]'), '');

      // 3. Pega os QUATRO últimos dígitos do número.
      String loginCode = "";
      if (unmaskedPhone.length >= 4) {
        loginCode = unmaskedPhone.substring(unmaskedPhone.length - 4);
      }

      /*
      IMPORTANTE:
      Neste ponto, você deve salvar os dados no seu banco de dados.
      - O 'usuário' para login será a variável `loginCode`.
      - A 'senha' para login será a de `_passwordController.text`.
      - O email de `_emailController.text` deve ser salvo como um dado de contato,
        mas não será mais usado para o login.
      */

      // Apenas para fins de teste, vamos imprimir os valores.
      print('============================================');
      print('Formulário de Registo Válido!');
      print('Email de Contato: ${_emailController.text}');
      print('Novo "Usuário" de Login: $loginCode'); // Agora com 4 dígitos
      print('Senha: ${_passwordController.text}');
      print('============================================');

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Registo realizado com sucesso! Use os 4 últimos dígitos do seu celular para fazer login.',
          ),
          backgroundColor: AppColors.success,
          duration: Duration(seconds: 5),
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
