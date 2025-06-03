import 'package:levvu_client/core/constants/api_routes.dart';
import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/core/models/freight_request_response_model.dart';
import 'package:levvu_client/core/models/auth_model.dart';
import 'package:levvu_client/core/network/api_client.dart';
import 'package:levvu_client/core/network/interceptors/auth_interceptor.dart';
import 'package:levvu_client/core/repositories/auth_repository.dart';
import 'package:levvu_client/core/services/auth/auth_service.dart';
import 'package:levvu_client/config/env_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  final ApiClient _apiClient;
  late final AuthRepository _authRepository;

  ApiService._internal()
      : _apiClient = ApiClient(
          baseUrl: EnvConfig.mainApiUrl,
          baseUrlAuth: EnvConfig.authApiUrl,
        ) {
    _initializeAuthRepository();
  }

  Future<void> _initializeAuthRepository() async {
    final prefs = await SharedPreferences.getInstance();
    final authService = AuthService(prefs);
    _authRepository = AuthRepository(
      apiClient: _apiClient,
      authService: authService,
    );
    _apiClient.addInterceptor(AuthInterceptor(_authRepository));
  }

  ApiClient get apiClient => _apiClient;
  AuthRepository get authRepository => _authRepository;

  // MÉTODOS PÚBLICOS
  Future<ApiResponse<AuthModel>> register(
    String name,
    String email,
    String password,
    String phone,
  ) async {
    return await _apiClient.request<AuthModel>(
      method: 'POST',
      path: '/api/auth/register',
      body: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
      requiresAuth: false,
      fromJsonT: (json) => AuthModel.fromJson(json),
    );
  }

  Future<ApiResponse<AuthModel>> login(String email, String password) async {
    return await _apiClient.request<AuthModel>(
      method: 'POST',
      path: '/api/auth/login',
      body: {
        'email': email,
        'password': password,
      },
      requiresAuth: false,
      fromJsonT: (json) => AuthModel.fromJson(json),
    );
  }

  Future<ApiResponse<AuthModel>> refreshToken(String refreshToken) async {
    return await _apiClient.request<AuthModel>(
      method: 'POST',
      path: '/api/auth/refresh-token',
      body: {
        'refreshToken': refreshToken,
      },
      requiresAuth: false,
      isLogin: true,
      fromJsonT: (json) => AuthModel.fromJson(json),
    );
  }

  Future<ApiResponse<FreightRequestResponse>> createFreightRequest(
      FreightRequestModel request) async {
    return await _apiClient.request<FreightRequestResponse>(
      method: 'POST',
      path: ApiRoutes.freightRequest,
      body: request.toJson(),
      requiresAuth: true,
      fromJsonT: (json) => FreightRequestResponse.fromJson(json['data']),
    );
  }

  Future<ApiResponse<List<FreightRequestResponse>>> getClientFreights() async {
    try {
      return await _apiClient.request<List<FreightRequestResponse>>(
        method: 'GET',
        path: ApiRoutes.myRequests,
        requiresAuth: true,
        fromJsonT: (json) {
          if (json is! List) {
            throw const FormatException(
                'Resposta inválida: esperava uma lista de fretes');
          }
          return (json as List)
              .map((item) =>
                  FreightRequestResponse.fromJson(item as Map<String, dynamic>))
              .toList();
        },
      );
    } catch (e) {
      return ApiResponse<List<FreightRequestResponse>>(
        isSuccess: false,
        message: 'Erro ao buscar fretes: ${e.toString()}',
        data: [],
      );
    }
  }

  // Método público para verificação manual (opcional)
  static Future<bool> checkAndRefreshAuth() async {
    final instance = ApiService();
    return await instance._authRepository.isAuthenticated();
  }
}
