import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Validators {
  Validators._();

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Por favor, insira o seu nome completo.';
    if (value.trim().split(' ').length < 2)
      return 'Por favor, insira nome e apelido.';
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Por favor, insira o seu email.';
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value))
      return 'Por favor, insira um email válido.';
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty)
      return 'Por favor, insira o seu telefone.';
    final unmasked = value.replaceAll(RegExp(r'[^\d]'), '');
    if (unmasked.length != 11) return 'Telefone inválido.';
    return null;
  }

  static String? validateCpf(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Por favor, insira o seu CPF.';
    final unmaskedCpf = value.replaceAll(RegExp(r'[^\d]'), '').trim();
    if (unmaskedCpf.length != 11) return 'O CPF precisa ter 11 dígitos.';
    if (!CPFValidator.isValid(unmaskedCpf))
      return 'Este número de CPF é inválido.';
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Por favor, insira a sua cidade.';
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty)
      return 'Por favor, insira a sua palavra-passe.';
    if (value.length < 6)
      return 'A palavra-passe deve ter no mínimo 6 caracteres.';
    return null;
  }

  static String? validateLoginCode(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Por favor, insira o seu código de acesso.';
    if (value.length != 4) return 'O código deve ter exatamente 4 dígitos.';
    if (int.tryParse(value) == null)
      return 'O código deve conter apenas números.';
    return null;
  }
}
