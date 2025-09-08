// Importamos os pacotes que as nossas funções de validação precisam.
import 'package:cpf_cnpj_validator/cpf_validator.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

// Criamos uma classe para agrupar todas as nossas funções de validação.
// Usar métodos estáticos permite-nos chamá-los sem precisar de criar uma instância da classe.
class Validators {
  // Construtor privado para evitar que a classe seja instanciada.
  Validators._();

  /// Valida se o nome completo é válido.
  ///
  /// Verifica se o valor é diferente de null e se tem pelo menos dois nomes.
  /// Se o valor for inválido, retorna uma mensagem de erro.
  /// Se o valor for válido, retorna null.

  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira o seu nome completo.';
    }
    if (value.trim().split(' ').length < 2) {
      return 'Por favor, insira nome e apelido.';
    }
    return null; // Retorna null se for válido
  }

  /// Valida se o email é válido.
  ///
  /// Verifica se o valor é diferente de null, se tem pelo menos um caractere e
  /// se o formato é válido.
  /// Se o valor for inválido, retorna uma mensagem de erro.
  /// Se o valor for válido, retorna null.
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

  /// Valida se o telefone é válido.
  ///
  /// Verifica se o valor é diferente de null, se tem pelo menos um caractere e
  /// se o comprimento do telefone sem a máscara é igual a 11.
  /// Se o valor for inválido, retorna uma mensagem de erro.
  /// Se o valor for válido, retorna null.
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

  /// Valida se o código de acesso é válido.
  ///
  /// Verifica se o valor é diferente de null, se tem pelo menos um caractere e
  /// se o comprimento do código sem a máscara é igual a 4.
  /// Se o valor for inválido, retorna uma mensagem de erro.
  /// Se o valor for válido, retorna null.

  static String? validateLoginCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira o seu código de acesso.';
    }
    if (value.length != 4) {
      // ALTERADO AQUI
      return 'O código deve ter exatamente 4 dígitos.'; // ALTERADO AQUI
    }
    if (int.tryParse(value) == null) {
      return 'O código deve conter apenas números.';
    }
    return null; // Retorna null se for válido
  }

  /// Valida se o CPF é válido.
  ///
  /// Verifica se o valor é diferente de null, se tem pelo menos um caractere e
  /// se o CPF é matematicamente válido.
  /// Se o valor for inválido, retorna uma mensagem de erro.
  /// Se o valor for válido, retorna null.

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

  /// Valida se a cidade é válida.
  ///
  /// Verifica se o valor é diferente de null e se tem pelo menos um caractere.
  /// Se o valor for inválido, retorna uma mensagem de erro.
  /// Se o valor for válido, retorna null.
  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Por favor, insira a sua cidade.';
    }
    return null;
  }

  /// Valida se a palavra-passe é válida.
  ///
  /// Verifica se o valor é diferente de null e se tem pelo menos 6 caracteres.
  /// Se o valor for inválido, retorna uma mensagem de erro.
  /// Se o valor for válido, retorna null.
  /// A palavra-passe deve ter no mínimo 6 caracteres.
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
