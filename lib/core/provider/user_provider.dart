import 'package:flutter/material.dart';
import 'package:levvu_client/core/services/auth/auth_service.dart';
import 'package:levvu_client/core/models/auth_model.dart';
import 'package:levvu_client/core/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  AuthModel? _authData;
  bool _isLoading = true;

  //Getters
  AuthModel? get authData => _authData;
  bool get isAuthenticated => _authData != null;
  bool get isLoading => _isLoading;

  // Dados do usuário para fácil acesso
  String get userName => _authData?.user.fullName ?? 'Usuário';
  String get userEmail => _authData?.user.email ?? '';
  String get userPhone => _authData?.user.phoneNumber ?? '';
  String get userCpf => _authData?.user.cpf ?? '';
  bool get isClient => _authData?.user.userType == UserType.client;
  bool get isPartner => _authData?.user.userType == UserType.partner;
  String get userId => _authData?.user.id ?? '';

  // Inicialização - carregar dados de autenticação
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final authService = AuthService(prefs);
      final isAuthenticated = await authService.isAuthenticated();
      if (!isAuthenticated) {
        _authData = null;
        return;
      }

      // Carregar dados de autenticação
      _authData = await authService.getAuthData();
    } catch (e) {
      debugPrint('Erro ao inicializar UserProvider: $e');
      _authData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Atualizar dados após login
  Future<void> updateAuthData() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final authService = AuthService(prefs);
      _authData = await authService.getAuthData();
    } catch (e) {
      _authData = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Limpar dados após logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    final authService = AuthService(prefs);
    await authService.clearAuthData();
    _authData = null;
    notifyListeners();
  }

  // Atualizar dados do perfil
  Future<void> updateUserProfile({
    required String fullName,
    required String phoneNumber,
    required bool whatsappNotifications,
    required bool emailNotifications,
  }) async {
    if (_authData == null) return;

    // Criar novo modelo de usuário com dados atualizados
    final updatedUser = UserModel(
      id: _authData!.user.id,
      email: _authData!.user.email,
      fullName: fullName,
      cpf: _authData!.user.cpf,
      phoneNumber: phoneNumber,
      userType: _authData!.user.userType,
      acceptedTerm: _authData!.user.acceptedTerm,
      whatsappNotifications: whatsappNotifications,
      emailNotifications: emailNotifications,
      status: _authData!.user.status,
      profileId: _authData!.user.profileId,
    );

    // Criar novo modelo de autenticação com dados atualizados
    final updatedAuthData = AuthModel(
      accessToken: _authData!.accessToken,
      refreshToken: _authData!.refreshToken,
      tokenExpiration: _authData!.tokenExpiration,
      user: updatedUser,
    );

    // Salvar dados atualizados
    final prefs = await SharedPreferences.getInstance();
    final authService = AuthService(prefs);
    await authService.saveAuthData(updatedAuthData);
    _authData = updatedAuthData;
    notifyListeners();

    // Aqui poderia ter uma chamada para API para sincronizar com backend
    // await ApiService.updateUserProfile(...);
  }
}
