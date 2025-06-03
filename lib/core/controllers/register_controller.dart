import 'package:flutter/material.dart';
import 'package:levvu_client/core/models/user_register_model.dart';
import 'package:levvu_client/core/repositories/auth_repository.dart';
import 'package:levvu_client/core/services/api/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:levvu_client/core/services/auth/auth_service.dart';

class RegisterController with ChangeNotifier {
  bool _isLoading = false;
  String? _errorMessage;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<bool> register({
    required BuildContext context,
    required UserRegisterModel userModel,
    required Function navigateToLogin,
  }) async {
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
      final response = await authRepository.register(userModel);

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.green,
          ),
        );

        navigateToLogin();
        return true;
      }

      _errorMessage = response.message;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: Colors.red,
        ),
      );
      return false;
    } catch (e) {
      _errorMessage = 'Erro ao realizar cadastro: ${e.toString()}';
      ScaffoldMessenger.of(context).showSnackBar(
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
