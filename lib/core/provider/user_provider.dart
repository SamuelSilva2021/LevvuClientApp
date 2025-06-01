import 'package:flutter/material.dart';
import 'package:levvu_client/core/models/auth_model.dart';
import 'package:levvu_client/core/models/user_login_response_model.dart';
import 'package:levvu_client/core/models/user_model.dart';
import 'package:levvu_client/core/repositories/auth_repository.dart';

class UserProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  AuthModel? _authData;
  UserLoginResponseModel? _user;
  bool _isLoading = true;

  UserProvider(this._authRepository) {
    _loadUserData();
  }

  AuthModel? get authData => _authData;
  UserLoginResponseModel? get user => _user;
  bool get isAuthenticated => _authData != null && _user != null;
  bool get isLoading => _isLoading;

  // Dados do usuário para fácil acesso
  String get userName => _authData?.user.fullName ?? 'Usuário';
  String get userEmail => _authData?.user.email ?? '';
  String get userPhone => _authData?.user.phoneNumber ?? '';
  bool get isClient => _authData?.user.userType == UserType.client;
  bool get isPartner => _authData?.user.userType == UserType.partner;
  String get userId => _authData?.user.id ?? '';

  Future<void> _loadUserData() async {
    _isLoading = true;
    notifyListeners();

    _authData = await _authRepository.getAuthData();
    _user = _authData?.user;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> setUser(AuthModel authData) async {
    _isLoading = true;
    notifyListeners();

    await _authRepository.saveAuthData(authData);
    _authData = authData;
    _user = authData.user;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    await _authRepository.logout();
    _authData = null;
    _user = null;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateUser(UserLoginResponseModel updatedUser) async {
    if (_authData != null) {
      _isLoading = true;
      notifyListeners();

      final updatedAuthData = AuthModel(
        token: _authData!.token,
        refreshToken: _authData!.refreshToken,
        user: updatedUser,
        tokenExpiration: _authData!.tokenExpiration,
      );
      await setUser(updatedAuthData);

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateUserProfile({
    required String fullName,
    required String phoneNumber,
    required bool whatsappNotifications,
    required bool emailNotifications,
  }) async {
    if (_authData != null) {
      _isLoading = true;
      notifyListeners();

      final updatedUser = UserLoginResponseModel(
        id: _authData!.user.id,
        fullName: fullName,
        email: _authData!.user.email,
        phoneNumber: phoneNumber,
        userType: _authData!.user.userType,
        whatsappNotifications: whatsappNotifications,
        emailNotifications: emailNotifications,
        acceptedTerm: _authData!.user.acceptedTerm,
        status: _authData!.user.status,
        profileId: _authData!.user.profileId,
      );

      await updateUser(updatedUser);

      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAuthData() async {
    _isLoading = true;
    notifyListeners();

    _authData = await _authRepository.getAuthData();
    _user = _authData?.user;

    _isLoading = false;
    notifyListeners();
  }

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    await _loadUserData();

    _isLoading = false;
    notifyListeners();
  }
}
