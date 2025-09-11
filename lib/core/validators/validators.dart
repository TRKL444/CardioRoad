// Importamos os pacotes que as nossas funções de validação precisam.
import 'package:cpf_cnpj_validator/cpf_validator.dart';

// Criamos uma classe para agrupar todas as nossas funções de validação.
class Validators {
  // Construtor privado para evitar que a classe seja instanciada.
  Validators._();

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira o seu nome completo.';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Por favor, insira nome e apelido.';
    }
    return null; // Retorna null se for válido
  }

  static String? validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira o seu email.';
    }
    // Usa uma expressão regular (Regex) para verificar se o formato do email é válido.
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
      return 'Por favor, insira um email válido.';
    }
    return null;
  }

  static String? validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira o seu telefone.';
    }
    // Valida o comprimento do telefone sem a máscara.
    final unmaskedPhone = value.replaceAll(RegExp(r'[^\d]'), '');
    if (unmaskedPhone.length != 11) {
      return 'Telefone inválido. Inclua o DDD.';
    }
    return null;
  }

  static String? validateCpf(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira o seu CPF.';
    }
    final unmaskedCpf = value.replaceAll(RegExp(r'[^\d]'), '').trim();
    if (unmaskedCpf.length != 11) {
      return 'O CPF precisa ter 11 dígitos.';
    }
    if (!CPFValidator.isValid(unmaskedCpf)) {
      return 'Este número de CPF é inválido.';
    }
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira a sua cidade.';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira a sua palavra-passe.';
    }
    if (value.length < 6) {
      return 'A palavra-passe deve ter no mínimo 6 caracteres.';
    }
    return null;
  }

  // FUNÇÃO CORRETA PARA O CÓDIGO DE LOGIN DE 4 DÍGITOS
  static String? validateLoginCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira o seu código de acesso.';
    }
    if (value.length != 4) {
      return 'O código deve ter exatamente 4 dígitos.';
    }
    // Verifica se o valor contém apenas números.
    if (int.tryParse(value) == null) {
      return 'O código deve conter apenas números.';
    }
    return null; // Retorna null se for válido
  }
}
