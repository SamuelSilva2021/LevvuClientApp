import 'package:flutter/material.dart';
import 'package:levvu_client/core/services/auth/auth_service.dart';
import 'package:levvu_client/core/models/auth_model.dart';

class UserProvider extends ChangeNotifier{
  AuthModel? _authData;
  bool _isLoading = true;

  //Getters
  AuthModel? get authData => _authData;
  bool get isAuthenticated => _authData != null;
  bool get isLoading => _isLoading;

  // Dados do usuário para fácil acesso
  String get userName => _authData?.userData['fullName'] ?? 'Usuário';
  String get userEmail => _authData?.userData['email'] ?? '';
  String get userPhone => _authData?.userData['phoneNumber'] ?? '';
  String get userCpf => _authData?.userData['cpf'] ?? '';
  bool get isClient => _authData?.userData['isClient'] ?? true;
  bool get isPartner => _authData?.userData['isPartner'] ?? false;
  String get userId => _authData?.userData['id'] ?? '';

  // Inicialização - carregar dados de autenticação
  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _authData = await AuthService.getAuthData();
    } catch (e) {
      // Tratar erro de carregamento
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
    _authData = await AuthService.getAuthData();
  } catch (e) {
    _authData = null;
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}

  // Limpar dados após logout
  Future<void> logout() async {
    await AuthService.logout();
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
    
    // Criar cópia dos dados atuais
    final updatedUserData = Map<String, dynamic>.from(_authData!.userData);
    
    // Atualizar campos
    updatedUserData['fullName'] = fullName;
    updatedUserData['phoneNumber'] = phoneNumber;
    updatedUserData['whatsappNotifications'] = whatsappNotifications;
    updatedUserData['emailNotifications'] = emailNotifications;
    
    // Criar novo modelo de autenticação com dados atualizados
    final updatedAuthData = AuthModel(
      accessToken: _authData!.accessToken,
      refreshToken: _authData!.refreshToken,
      tokenExpiration: _authData!.tokenExpiration,
      userData: updatedUserData,
    );
    
    // Salvar dados atualizados
    await AuthService.saveAuthData(updatedAuthData);
    _authData = updatedAuthData;
    notifyListeners();
    
    // Aqui poderia ter uma chamada para API para sincronizar com backend
    // await ApiService.updateUserProfile(...);
  }
}