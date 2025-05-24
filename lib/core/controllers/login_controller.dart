import 'package:flutter/material.dart';
import 'package:levvu_client/core/provider/user_provider.dart';
import 'package:levvu_client/core/services/api/api_service.dart';
import 'package:levvu_client/core/services/auth/auth_service.dart';
import 'package:provider/provider.dart';

class LoginController with ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> checkExistingSession(Function navigateToHome) async {
    _isLoading = true;
    notifyListeners();

    try {
      final isAuthenticated = await AuthService.isAuthenticated();

      if (isAuthenticated) {
        navigateToHome();
      }
    } catch (e) {
      // Tratamento de erro
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
    required Function navigateToHome,
    required GlobalKey<ScaffoldMessengerState> scaffoldKey,
  }) async {
    if (email.isEmpty || password.isEmpty) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.login(email, password);

      _isLoading = false;
      notifyListeners();

      scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text(response.message),
          backgroundColor: response.isSuccess ? Colors.green : Colors.red,
        ),
      );

      if (response.isSuccess) {
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        await userProvider.updateAuthData();
        navigateToHome();
      }
    } catch (e) {
      _isLoading = false;
      notifyListeners();

      scaffoldKey.currentState?.showSnackBar(
        SnackBar(
          content: Text('Erro ao realizar login: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
