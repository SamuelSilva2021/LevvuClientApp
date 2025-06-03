import 'package:levvu_client/core/models/auth_model.dart';
import 'package:levvu_client/core/models/user_register_model.dart';
import 'package:levvu_client/core/network/api_client.dart';
import 'package:levvu_client/core/services/auth/auth_service.dart';
import 'package:flutter/foundation.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final AuthService _authService;

  AuthRepository({
    required ApiClient apiClient,
    required AuthService authService,
  })  : _apiClient = apiClient,
        _authService = authService;

  Future<ApiResponse<AuthModel>> login(String email, String password) async {
    final response = await _apiClient.request<AuthModel>(
      method: 'POST',
      path: '/api/auth/login',
      body: {
        'email': email,
        'password': password,
      },
      requiresAuth: false,
      fromJsonT: (json) => AuthModel.fromJson(json),
      isLogin: true,
    );

    if (response.isSuccess && response.data != null) {
      await _authService.saveAuthData(response.data!);
    }

    return response;
  }

  Future<ApiResponse<AuthModel>> register(UserRegisterModel userModel) async {
    final response = await _apiClient.request<AuthModel>(
      method: 'POST',
      path: '/api/auth/register',
      body: userModel.toJson(),
      requiresAuth: false,
      fromJsonT: (json) => AuthModel.fromJson(json),
    );

    if (response.isSuccess && response.data != null) {
      await _authService.saveAuthData(response.data!);
    }

    return response;
  }

  Future<ApiResponse<AuthModel>> refreshToken() async {
    final authData = await _authService.getAuthData();
    if (authData == null) {
      return ApiResponse<AuthModel>(
        isSuccess: false,
        message: 'Usuário não autenticado',
        data: null,
      );
    }

    debugPrint(
        '🔄 Obtendo refresh token: ${authData.refreshToken.isNotEmpty ? 'Token encontrado' : 'Token não encontrado'}');
    return await _apiClient.request<AuthModel>(
      method: 'POST',
      path: '/api/auth/refresh-token',
      body: {
        'refreshToken': authData.refreshToken,
      },
      requiresAuth: false,
      isLogin: true,
      fromJsonT: (json) => AuthModel.fromJson(json),
    );
  }

  Future<bool> isAuthenticated() async {
    return await _authService.isAuthenticated();
  }

  Future<void> logout() async {
    await _authService.clearAuthData();
  }

  Future<void> saveAuthData(AuthModel authData) async {
    await _authService.saveAuthData(authData);
  }

  Future<AuthModel?> getAuthData() async {
    return await _authService.getAuthData();
  }

  Future<void> clearAuthData() async {
    await _authService.clearAuthData();
  }

  Future<String?> getToken() async {
    return await _authService.getToken();
  }

  Future<String?> getRefreshToken() async {
    return await _authService.getRefreshToken();
  }
}
