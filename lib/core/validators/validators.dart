// Importamos os pacotes que as nossas funções de validação precisam.
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// Criamos uma classe para agrupar todas as nossas funções de validação.
// Usar métodos estáticos permite-nos chamá-los sem precisar de criar uma instância da classe.
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

  static String? validatePhone(
    String? value,
    MaskTextInputFormatter formatter,
  ) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o seu telefone.';
    }
    // Valida o comprimento do telefone sem a máscara.
    if (formatter.getUnmaskedText().length != 11) {
      return 'Telefone inválido.';
    }
    return null;
  }

  static String? validateCpf(String? value, MaskTextInputFormatter formatter) {
    if (value == null || value.isEmpty) {
      return 'Por favor, insira o seu CPF.';
    }
    // Usa o pacote para verificar se o CPF é matematicamente válido.
    if (!CPFValidator.isValid(formatter.getUnmaskedText())) {
      return 'CPF inválido.';
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
}
