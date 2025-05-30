import 'package:levvu_client/core/constants/api_routes.dart';
import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/core/models/freight_request_response_model.dart';
import 'package:levvu_client/core/models/auth_model.dart';
import 'package:levvu_client/core/network/api_client.dart';
import 'package:levvu_client/core/network/interceptors/auth_interceptor.dart';
import 'package:levvu_client/core/repositories/auth_repository.dart';
import 'package:levvu_client/core/services/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String _baseUrl = 'http://10.0.2.2:5006';
  static const String _baseUrlAuth = 'http://10.0.2.2:5003';
  static final ApiService _instance = ApiService._internal();

  factory ApiService() => _instance;

  final ApiClient _apiClient;
  late final AuthRepository _authRepository;

  ApiService._internal()
      : _apiClient = ApiClient(
          baseUrl: _baseUrl,
          baseUrlAuth: _baseUrlAuth,
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
    return await _apiClient.request<List<FreightRequestResponse>>(
      method: 'GET',
      path: ApiRoutes.myRequests,
      requiresAuth: true,
      fromJsonT: (json) => (json['data'] as List)
          .map((item) => FreightRequestResponse.fromJson(item))
          .toList(),
    );
  }

  // Método público para verificação manual (opcional)
  static Future<bool> checkAndRefreshAuth() async {
    final instance = ApiService();
    return await instance._authRepository.isAuthenticated();
  }
}
