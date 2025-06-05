import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:levvu_client/core/network/interceptors/interceptor.dart';
import 'package:flutter/foundation.dart';

class ApiResponse<T> {
  final bool isSuccess;
  final String message;
  final T? data;
  final List<dynamic>? errors;
  final int? statusCode;
  final DateTime? timestamp;
  final String? path;

  ApiResponse({
    required this.isSuccess,
    required this.message,
    this.data,
    this.errors,
    this.statusCode,
    this.timestamp,
    this.path,
  });

  factory ApiResponse.fromJson(
      Map<String, dynamic> json, T Function(dynamic) fromJsonT) {
    return ApiResponse<T>(
      isSuccess: json['isSuccess'] as bool,
      message: json['message'] as String? ?? 'Operação realizada com sucesso',
      data: json['data'] != null ? fromJsonT(json['data']) : null,
      errors: json['errors'] as List<dynamic>?,
      statusCode: json['statusCode'] as int?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : null,
      path: json['path'] as String?,
    );
  }
}

class ApiClient {
  final String baseUrl;
  final String baseUrlAuth;
  final http.Client _client;
  final List<Interceptor> _interceptors;

  ApiClient({
    required this.baseUrl,
    required this.baseUrlAuth,
    http.Client? client,
    List<Interceptor>? interceptors,
  })  : _client = client ?? http.Client(),
        _interceptors = interceptors ?? [];

  void addInterceptor(Interceptor interceptor) {
    _interceptors.add(interceptor);
  }

  // Headers básicos
  Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Headers com token de autenticação
  Map<String, String> _authHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Métodos HTTP diretos
  Future<http.Response> get(Uri uri, {Map<String, String>? headers}) async {
    return await _client.get(uri, headers: headers);
  }

  Future<http.Response> post(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return await _client.post(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> put(
    Uri uri, {
    Map<String, String>? headers,
    Object? body,
  }) async {
    return await _client.put(
      uri,
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );
  }

  Future<http.Response> delete(Uri uri, {Map<String, String>? headers}) async {
    return await _client.delete(uri, headers: headers);
  }

  Future<ApiResponse<T>> request<T>({
    required String method,
    required String path,
    Map<String, String>? headers,
    Object? body,
    bool requiresAuth = true,
    bool isLogin = false,
    required T Function(dynamic) fromJsonT,
  }) async {
    try {
      final url = isLogin ? baseUrlAuth : baseUrl;
      final uri = Uri.parse('$url$path');
      final requestHeaders = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      };

      // Processa interceptors antes de enviar a requisição
      for (final interceptor in _interceptors) {
        final result = await interceptor.onRequest(
          method: method,
          path: path,
          headers: requestHeaders,
          body: body as Map<String, dynamic>?,
        );
        if (result != null) {
          return result as ApiResponse<T>;
        }
      }


      final request = http.Request(method, uri);
      request.headers.addAll(requestHeaders);
      if (body != null) {
        request.body = jsonEncode(body);
      }

      final streamedResponse = await _client.send(request);
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('✅ [RESPONSE] Status: ${response.statusCode}');

      // Processa interceptors para a resposta
      for (final interceptor in _interceptors) {
        final result = await interceptor.onResponse(
          statusCode: response.statusCode,
          headers: response.headers,
          body: response.body,
        );
        if (result != null) {
          return result as ApiResponse<T>;
        }
      }

      if (response.statusCode >= 200 && response.statusCode < 300) {
        if (response.body.isEmpty) {
          return ApiResponse<T>(
            isSuccess: true,
            message: 'Operação realizada com sucesso',
            data: null,
          );
        }
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        return ApiResponse.fromJson(json, fromJsonT);
      }

      // Processa interceptors para erros
      for (final interceptor in _interceptors) {
        final result = await interceptor.onError(response);
        if (result != null) {
          return result as ApiResponse<T>;
        }
      }

      return ApiResponse<T>(
        isSuccess: false,
        message: 'Erro na requisição: ${response.statusCode}',
        data: null,
      );
    } catch (e) {
      debugPrint('❌ [ERROR] $e');
      return ApiResponse<T>(
        isSuccess: false,
        message: 'Erro na requisição',
        data: null,
      );
    }
  }

  void dispose() {
    _client.close();
  }
}
