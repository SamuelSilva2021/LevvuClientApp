import 'package:flutter/foundation.dart';

class MockData {
  static bool useMockData = true;

  static void toggleMockData() {
    useMockData = !useMockData;
    debugPrint('Usando dados mockados: $useMockData');
  }

  // Aqui você pode adicionar seus dados mockados
  static final Map<String, dynamic> mockData = {
    'auth': {
      'token': 'mock_token_123456',
      'refreshToken': 'mock_refresh_token_123456',
      'userData': {
        'id': '1',
        'fullName': 'Usuário Teste',
        'email': 'teste@exemplo.com',
        'phoneNumber': '(11) 99999-9999',
        'cpf': '123.456.789-00',
        'isClient': true,
        'isPartner': false,
      }
    },
    'login_credentials': {
      'valid': {'email': 'teste@exemplo.com', 'password': 'Teste@123'},
      'invalid': {'email': 'erro@exemplo.com', 'password': 'senha_errada'}
    }
  };
}
