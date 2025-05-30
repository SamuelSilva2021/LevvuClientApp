import 'package:flutter/material.dart';
import 'package:levvu_client/core/provider/user_provider.dart';
import 'package:levvu_client/core/repositories/auth_repository.dart';
import 'package:levvu_client/core/services/api/api_service.dart';
import 'package:levvu_client/core/models/user_login_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:levvu_client/core/services/auth/auth_service.dart';

class LoginController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> checkExistingSession(Function navigateToHome) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final authService = AuthService(prefs);
      final authRepository = AuthRepository(
        apiClient: ApiService().apiClient,
        authService: authService,
      );
      final isAuthenticated = await authRepository.isAuthenticated();

      if (isAuthenticated) {
        navigateToHome();
      }
    } catch (e) {
      _errorMessage = 'Erro ao verificar sessão: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required BuildContext context,
    required String email,
    required String password,
    required Function navigateToHome,
    required GlobalKey<ScaffoldMessengerState> scaffoldKey,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      _errorMessage = 'Por favor, preencha todos os campos';
      notifyListeners();
      return false;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final authService = AuthService(prefs);
      final authRepository = AuthRepository(
        apiClient: ApiService().apiClient,
        authService: authService,
      );
      final response = await authRepository.login(email, password);

      if (response.isSuccess && response.data != null) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.updateAuthData();

        scaffoldKey.currentState?.showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );

        navigateToHome();
        return true;
      }

      _errorMessage = response.message;
      scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } catch (e) {
      _errorMessage = 'Erro ao realizar login: ${e.toString()}';
      scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(_errorMessage!),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
