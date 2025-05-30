import 'package:flutter/foundation.dart';
import 'package:levvu_client/core/repositories/auth_repository.dart';
import 'package:levvu_client/core/services/api/api_service.dart';

class LoginController extends ChangeNotifier {
  final AuthRepository _authRepository;
  bool _isLoading = false;
  String? _error;

  LoginController() : _authRepository = ApiService().authRepository;

  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      debugPrint('🔑 Iniciando processo de login...');
      final response = await _authRepository.login(email, password);
      debugPrint('📥 Resposta do login: ${response.isSuccess}');

      if (!response.isSuccess) {
        _error = response.message;
        debugPrint('❌ Erro no login: $_error');
        return false;
      }

      debugPrint('✅ Login realizado com sucesso');
      return true;
    } catch (e) {
      _error = 'Erro ao realizar login: $e';
      debugPrint('❌ Exceção no login: $_error');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
