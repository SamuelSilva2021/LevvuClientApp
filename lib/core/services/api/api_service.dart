import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:levvu_client/core/constants/api_routes.dart';
import 'package:levvu_client/core/exceptions/api_exception.dart';
import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/core/models/freight_request_response_model.dart';
import 'package:levvu_client/core/services/auth/auth_service.dart';
import 'package:levvu_client/core/models/api_response_model.dart';
import 'package:levvu_client/core/models/auth_model.dart';
import 'package:levvu_client/core/models/user_register_model.dart';

class ApiService {
  
  static String get _baseUrlAuth {
    if (kIsWeb) {
      return 'http://localhost:5006';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5006';
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:5006';
    } else {
      return 'http://192.168.1.100:5006';
    }
  }
  
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:5003';
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:5003';
    } else if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return 'http://localhost:5003';
    } else {
      return 'http://192.168.1.100:5003';
    }
  }

  final http.Client _client;
  static bool _isRefreshing = false; // Flag para evitar múltiplas renovações simultâneas

  static final ApiService _instance = ApiService._internal(http.Client());
  factory ApiService() => _instance;
  ApiService._internal(this._client);

  // Headers básicos
  static Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Headers com token de autenticação
  static Map<String, String> _authHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // MÉTODO PRINCIPAL COM RENOVAÇÃO AUTOMÁTICA
  Future<ApiResponse<T>> _request<T>({
    required String method,
    required String path,
    dynamic body,
    bool requiresAuth = false,
    T Function(dynamic)? fromJsonT,
    int retryCount = 0,
  }) async {
    try {
      final uri = Uri.parse('$_baseUrl$path');
      final headers = requiresAuth ? _authHeaders(await _getToken()) : _headers();

      // Faz a requisição
      http.Response response = await _makeHttpRequest(method, uri, headers, body);

      // Se receber 401 e for uma requisição autenticada, tenta renovar o token
      if (response.statusCode == 401 && requiresAuth && retryCount == 0) {
        debugPrint('Token expirado, tentando renovar...');
        
        final tokenRefreshed = await _handleTokenExpiration();
        
        if (tokenRefreshed) {
          debugPrint('Token renovado com sucesso, tentando novamente...');
          // Tenta a requisição novamente com o novo token
          return _request<T>(
            method: method,
            path: path,
            body: body,
            requiresAuth: requiresAuth,
            fromJsonT: fromJsonT,
            retryCount: 1, // Evita loop infinito
          );
        } else {
          // Se não conseguir renovar, redireciona para login
          await _handleAuthFailure();
          throw ApiException(message: 'Sessão expirada. Faça login novamente.');
        }
      }

      // Processa a resposta normalmente
      return _handleResponse<T>(response, fromJsonT);
      
    } on http.ClientException catch (e) {
      throw ApiException(message: 'Erro de conexão: ${e.message}');
    } catch (e) {
      if (e is ApiException) rethrow;
      throw ApiException(message: 'Erro desconhecido: ${e.toString()}');
    }
  }

  // Método auxiliar para fazer requisições HTTP
  Future<http.Response> _makeHttpRequest(
    String method, 
    Uri uri, 
    Map<String, String> headers, 
    dynamic body
  ) async {
    switch (method.toUpperCase()) {
      case 'GET':
        return await _client.get(uri, headers: headers);
      case 'POST':
        return await _client.post(uri, headers: headers, body: jsonEncode(body));
      case 'PUT':
        return await _client.put(uri, headers: headers, body: jsonEncode(body));
      case 'DELETE':
        return await _client.delete(uri, headers: headers);
      default:
        throw ApiException(message: 'Método HTTP inválido: $method');
    }
  }

  // Gerencia a renovação do token quando expira
  Future<bool> _handleTokenExpiration() async {
    // Evita múltiplas renovações simultâneas
    if (_isRefreshing) {
      // Aguarda a renovação em curso
      while (_isRefreshing) {
        await Future.delayed(const Duration(milliseconds: 100));
      }
      // Verifica se a renovação foi bem-sucedida
      final authData = await AuthService.getAuthData();
      return authData != null && !authData.isTokenExpired;
    }

    _isRefreshing = true;
    
    try {
      final authData = await AuthService.getAuthData();
      if (authData == null) {
        return false;
      }

      final response = await _refreshTokenRequest(authData.refreshToken);

      if (response.isSuccess && response.data != null) {
        final newAuthModel = AuthModel(
          accessToken: response.data!['token'],
          refreshToken: response.data!['refreshToken'],
          tokenExpiration: DateTime.parse(response.data!['tokenExpiration']),
          userData: authData.userData,
        );

        await AuthService.saveAuthData(newAuthModel);
        debugPrint('Token renovado com sucesso!');
        return true;
      }

      return false;
    } catch (e) {
      debugPrint('Erro ao renovar token: $e');
      return false;
    } finally {
      _isRefreshing = false;
    }
  }

  // Requisição específica para renovar token
  Future<ApiResponse<Map<String, dynamic>>> _refreshTokenRequest(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrlAuth/api/auth/refresh-token'),
        headers: _headers(),
        body: jsonEncode({'refreshToken': refreshToken}),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse(
          isSuccess: responseData['isSuccess'] ?? true,
          message: responseData['message'] ?? 'Token renovado com sucesso!',
          data: responseData['data'],
        );
      } else {
        return ApiResponse(
          isSuccess: false,
          message: responseData['message'] ?? 'Erro ao renovar token',
        );
      }
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: 'Erro de conexão ao renovar token: ${e.toString()}',
      );
    }
  }

  // Lida com falha de autenticação (redireciona para login)
  Future<void> _handleAuthFailure() async {
    await AuthService.logout();
    // Aqui você pode adicionar navegação para tela de login
    // Por exemplo: GetIt.instance<NavigationService>().navigateToLogin();
  }

  ApiResponse<T> _handleResponse<T>(
    http.Response response,
    T Function(dynamic)? fromJsonT,
  ) {
    final responseData = jsonDecode(response.body);

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return ApiResponse<T>(
        isSuccess: responseData['isSuccess'] ?? true,
        message: responseData['message'] ?? 'Sucesso',
        data: fromJsonT != null && responseData['data'] != null 
          ? fromJsonT(responseData['data']) 
          : null,
      );
    } else {
      throw ApiException(
        message: responseData['message'] ?? 'Requisição falhou',
        statusCode: response.statusCode,
        data: responseData,
      );
    }
  }

  Future<String> _getToken() async {
    final token = await AuthService.getAccessToken();
    if (token == null) {
      throw ApiException(message: 'Token de acesso não disponível');
    }
    return token;
  }

  // MÉTODOS PÚBLICOS - mantidos iguais
  static Future<ApiResponse<Map<String, dynamic>>> registerUser(UserRegisterModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrlAuth/api/auth/register'),
        headers: _headers(),
        body: jsonEncode(user.toJson()),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['data'] != null &&
            responseData['data']['token'] != null &&
            responseData['data']['refreshToken'] != null) {
          final userData = {
            'id': responseData['data']['userId'],
            'email': responseData['data']['email'],
            'fullName': user.fullName,
          };

          final authModel = AuthModel(
            accessToken: responseData['data']['token'],
            refreshToken: responseData['data']['refreshToken'],
            tokenExpiration: DateTime.now().add(const Duration(minutes: 60)),
            userData: userData,
          );

          await AuthService.saveAuthData(authModel);
        }

        return ApiResponse(
          isSuccess: responseData['isSuccess'] ?? true,
          message: responseData['message'] ?? 'Cadastro realizado com sucesso!',
          data: responseData['data'],
        );
      } else {
        return ApiResponse(
          isSuccess: false,
          message: responseData['message'] ?? 'Erro ao realizar cadastro',
        );
      }
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: 'Erro de conexão: ${e.toString()}',
      );
    }
  }

  static Future<ApiResponse<Map<String, dynamic>>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$_baseUrlAuth/api/auth/login'),
        headers: _headers(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        if (responseData['data'] != null &&
            responseData['data']['token'] != null &&
            responseData['data']['refreshToken'] != null) {
          final userData = responseData['data']['user'] ?? {};

          final authModel = AuthModel(
            accessToken: responseData['data']['token'],
            refreshToken: responseData['data']['refreshToken'],
            tokenExpiration: DateTime.parse(responseData['data']['tokenExpiration'] ??
                DateTime.now().add(const Duration(minutes: 60)).toIso8601String()),
            userData: userData,
          );

          await AuthService.saveAuthData(authModel);
        }

        return ApiResponse(
          isSuccess: responseData['isSuccess'] ?? true,
          message: responseData['message'] ?? 'Login realizado com sucesso!',
          data: responseData['data'],
        );
      } else {
        return ApiResponse(
          isSuccess: false,
          message: responseData['message'] ?? 'Erro ao realizar login',
        );
      }
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: 'Erro de conexão: ${e.toString()}',
      );
    }
  }

  // Métodos de negócio - agora com renovação automática
  Future<ApiResponse<FreightRequestResponse>> createFreightRequest(FreightRequestModel request) async {
    try {
      final response = await _request(
        method: 'POST',
        path: ApiRoutes.freightRequest,
        body: request.toJson(),
        requiresAuth: true,
        fromJsonT: (json) => FreightRequestResponse.fromJson(json),
      );
      return response;
    } on ApiException catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: e.message,
      );
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: 'Erro de conexão: ${e.toString()}',
      );
    }
  }
 
  Future<ApiResponse<List<FreightRequestResponse>>> getClientFreights() async {
    try {
      final response = await _request(
        method: 'GET',
        path: ApiRoutes.myRequests,
        requiresAuth: true,
        fromJsonT: (jsonList) => (jsonList as List)
            .map((json) => FreightRequestResponse.fromJson(json))
            .toList(),
      );
      return response;
    } on ApiException catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: e.message,
      );
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: 'Erro ao listar fretes: ${e.toString()}',
      );
    }
  }

  // Método público para verificação manual (opcional)
  static Future<bool> checkAndRefreshAuth() async {
    final instance = ApiService();
    return await instance._handleTokenExpiration();
  }
}