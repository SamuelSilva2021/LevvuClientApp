import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class Validators{
  // Máscaras de input
  static final telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );
  
  static final cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  // VALIDADORES
  static String? validateName(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, digite seu nome completo';
  }
  
  // Verifica se contém apenas letras, espaços e acentos
  if (!RegExp(r'^[a-zA-ZÀ-ÿ\s]+$').hasMatch(value)) {
    return 'Não pode conter números ou caracteres especiais';
  }
  
  // Verifica se tem nome e sobrenome
  if (value.split(' ').length < 2) {
    return 'Digite nome e sobrenome';
  }
  
  return null;
}

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu e-mail';
    }
    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
      return 'Digite um e-mail válido';
    }
    return null;
  }

  static String? validatePhoneNumber(String? value, MaskTextInputFormatter mask) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu telefone';
    }
    if (!mask.isFill()) {
      return 'Digite um telefone válido: (99) 99999-9999';
    }
    return null;
  }

  static String? validateCPF(String? value, MaskTextInputFormatter mask) {
    if (value == null || value.isEmpty) {
      return 'Por favor, digite seu CPF';
    }
    if (!mask.isFill()) {
      return 'Digite um CPF válido: 999.999.999-99';
    }
    // Aqui poderia ter uma validação mais completa do CPF
    return null;
  }

  static String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Por favor, digite sua senha';
  }
  
  if (value.length < 6) {
    return 'A senha deve ter pelo menos 8 caracteres';
  }
  
  if (!RegExp(r'[A-Z]').hasMatch(value)) {
    return 'A senha deve conter pelo menos uma letra maiúscula';
  }
  
  if (!RegExp(r'[a-z]').hasMatch(value)) {
    return 'A senha deve conter pelo menos uma letra minúscula';
  }
  
  if (!RegExp(r'[0-9]').hasMatch(value)) {
    return 'A senha deve conter pelo menos um número';
  }
  
  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
    return 'A senha deve conter pelo menos um caractere especial (!@#\$% etc)';
  }
  
  return null;
}

  static String? validatePasswordConfirm(String? value, String senha) {
    if (value == null || value.isEmpty) {
      return 'Por favor, confirme sua senha';
    }
    if (value != senha) {
      return 'As senhas não coincidem';
    }
    return null;
  }
}