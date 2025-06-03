import 'package:flutter/foundation.dart';
import 'package:levvu_client/core/repositories/auth_repository.dart';
import 'package:levvu_client/core/network/interceptors/interceptor.dart';
import 'package:levvu_client/core/network/api_client.dart';
import 'package:levvu_client/core/models/auth_model.dart';

class AuthInterceptor implements Interceptor {
  final AuthRepository _authRepository;
  bool _isRefreshing = false;
  String? _lastRefreshedToken;

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

    final authData = await _authRepository.getAuthData();
    debugPrint(
        '🔑 Token para requisição $path: ${authData != null ? 'Encontrado' : 'Não encontrado'}');

    if (authData == null) {
      debugPrint('❌ Token não encontrado para a requisição: $path');
      return ApiResponse(
        isSuccess: false,
        message: 'Usuário não autenticado',
        data: null,
      );
    }

    // Verifica se o token está expirado
    if (authData.isTokenExpired) {
      debugPrint('⚠️ Token expirado, tentando renovar...');
      try {
        _isRefreshing = true;
        final response = await _authRepository.refreshToken();

        if (!response.isSuccess || response.data == null) {
          await _authRepository.logout();
          return ApiResponse(
            isSuccess: false,
            message: 'Sessão expirada. Por favor, faça login novamente.',
            data: null,
          );
        }

        _lastRefreshedToken = response.data!.token;
        headers['Authorization'] = 'Bearer ${response.data!.token}';
        debugPrint(
            '🔄 Token renovado com sucesso: Bearer ${response.data!.token}');
        return null;
      } catch (e) {
        debugPrint('❌ Erro ao renovar token: $e');
        await _authRepository.logout();
        return ApiResponse(
          isSuccess: false,
          message: 'Sessão expirada. Por favor, faça login novamente.',
          data: null,
        );
      } finally {
        _isRefreshing = false;
      }
    }

    headers['Authorization'] = 'Bearer ${authData.token}';
    debugPrint('🔑 Token adicionado aos headers: Bearer ${authData.token}');
    return null;
  }

  @override
  Future<ApiResponse?> onResponse({
    required int statusCode,
    required Map<String, String> headers,
    required String body,
  }) async {
    // Se não for erro de autenticação, retorna null para continuar o fluxo
    if (statusCode != 401 && statusCode != 404) {
      return null;
    }

    // Se já estiver renovando o token, retorna erro
    if (_isRefreshing) {
      await _authRepository.logout();
      return ApiResponse(
        isSuccess: false,
        message: 'Sessão expirada. Por favor, faça login novamente.',
        data: null,
      );
    }

    try {
      _isRefreshing = true;
      final response = await _authRepository.refreshToken();

      if (!response.isSuccess || response.data == null) {
        await _authRepository.logout();
        return ApiResponse(
          isSuccess: false,
          message: 'Sessão expirada. Por favor, faça login novamente.',
          data: null,
        );
      }

      _lastRefreshedToken = response.data!.token;
      debugPrint('🔄 Token renovado com sucesso');
      return null;
    } catch (e) {
      debugPrint('❌ Erro ao renovar token: $e');
      await _authRepository.logout();
      return ApiResponse(
        isSuccess: false,
        message: 'Sessão expirada. Por favor, faça login novamente.',
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
      final response = await _authRepository.refreshToken();

      if (!response.isSuccess || response.data == null) {
        await _authRepository.logout();
        return ApiResponse(
          isSuccess: false,
          message: 'Sessão expirada. Por favor, faça login novamente.',
          data: null,
        );
      }

      _lastRefreshedToken = response.data!.token;
      debugPrint('🔄 Token renovado com sucesso');
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
