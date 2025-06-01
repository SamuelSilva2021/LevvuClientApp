import 'package:flutter/foundation.dart';
import 'package:levvu_client/core/repositories/auth_repository.dart';
import 'package:levvu_client/core/network/interceptors/interceptor.dart';
import 'package:levvu_client/core/network/api_client.dart';

class AuthInterceptor implements Interceptor {
  final AuthRepository _authRepository;
  bool _isRefreshing = false;

  AuthInterceptor(this._authRepository);

  @override
  Future<ApiResponse?> onRequest({
    required String method,
    required String path,
    required Map<String, String> headers,
    Map<String, dynamic>? body,
  }) async {
    // Se não precisar de autenticação, retorna null para continuar o fluxo
    if (!_requiresAuth(path)) {
      return null;
    }

    // Se estiver renovando o token, retorna null para continuar o fluxo
    if (_isRefreshing) {
      return null;
    }

    final token = await _authRepository.getToken();
    debugPrint(
        '🔑 Token para requisição $path: ${token != null ? 'Encontrado' : 'Não encontrado'}');

    if (token == null || token.isEmpty) {
      debugPrint('❌ Token não encontrado para a requisição: $path');
      return ApiResponse(
        isSuccess: false,
        message: 'Usuário não autenticado',
        data: null,
      );
    }

    headers['Authorization'] = 'Bearer $token';
    debugPrint('🔑 Token adicionado aos headers: Bearer $token');
    return null;
  }

  @override
  Future<ApiResponse?> onResponse({
    required int statusCode,
    required Map<String, String> headers,
    required String body,
  }) async {
    // Se não for erro de autenticação, retorna null para continuar o fluxo
    if (statusCode != 401) {
      return null;
    }

    // Se já estiver renovando o token, retorna erro
    if (_isRefreshing) {
      return ApiResponse(
        isSuccess: false,
        message: 'Sessão expirada. Por favor, faça login novamente.',
        data: null,
      );
    }

    try {
      _isRefreshing = true;
      final refreshToken = await _authRepository.getRefreshToken();

      // Verifica se o refresh token existe e não está vazio
      if (refreshToken == null || refreshToken.isEmpty) {
        await _authRepository.logout();
        return ApiResponse(
          isSuccess: false,
          message: 'Sessão expirada. Por favor, faça login novamente.',
          data: null,
        );
      }

      final response = await _authRepository.refreshToken();
      if (!response.isSuccess || response.data == null) {
        await _authRepository.logout();
        return ApiResponse(
          isSuccess: false,
          message: 'Sessão expirada. Por favor, faça login novamente.',
          data: null,
        );
      }

      // Retorna null para continuar o fluxo com o novo token
      return null;
    } catch (e) {
      await _authRepository.logout();
      return ApiResponse(
        isSuccess: false,
        message: 'Erro ao renovar sessão: ${e.toString()}',
        data: null,
      );
    } finally {
      _isRefreshing = false;
    }
  }

  @override
  Future<ApiResponse?> onError(dynamic error) async {
    // Se não for erro de autenticação, retorna null para continuar o fluxo
    if (error is! Exception || !error.toString().contains('401')) {
      return null;
    }

    // Se já estiver renovando o token, retorna erro
    if (_isRefreshing) {
      return ApiResponse(
        isSuccess: false,
        message: 'Sessão expirada. Por favor, faça login novamente.',
        data: null,
      );
    }

    try {
      _isRefreshing = true;
      final refreshToken = await _authRepository.getRefreshToken();

      // Verifica se o refresh token existe e não está vazio
      if (refreshToken == null || refreshToken.isEmpty) {
        await _authRepository.logout();
        return ApiResponse(
          isSuccess: false,
          message: 'Sessão expirada. Por favor, faça login novamente.',
          data: null,
        );
      }

      final response = await _authRepository.refreshToken();
      if (!response.isSuccess || response.data == null) {
        await _authRepository.logout();
        return ApiResponse(
          isSuccess: false,
          message: 'Sessão expirada. Por favor, faça login novamente.',
          data: null,
        );
      }

      // Retorna null para continuar o fluxo com o novo token
      return null;
    } catch (e) {
      await _authRepository.logout();
      return ApiResponse(
        isSuccess: false,
        message: 'Erro ao renovar sessão: ${e.toString()}',
        data: null,
      );
    } finally {
      _isRefreshing = false;
    }
  }

  bool _requiresAuth(String path) {
    // Lista de paths que não requerem autenticação
    final publicPaths = [
      '/api/auth/login',
      '/api/auth/register',
      '/api/auth/refresh-token',
    ];

    return !publicPaths.contains(path);
  }
}
