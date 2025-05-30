import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/core/models/freight_request_response_model.dart';
import 'package:levvu_client/core/network/api_client.dart';
import 'package:levvu_client/core/repositories/auth_repository.dart';
import 'package:levvu_client/core/constants/api_routes.dart';

class FreightRepository {
  final ApiClient _apiClient;
  final AuthRepository _authRepository;

  FreightRepository({
    required ApiClient apiClient,
    required AuthRepository authRepository,
  })  : _apiClient = apiClient,
        _authRepository = authRepository;

  Future<ApiResponse<FreightRequestResponse>> createFreightRequest(
      FreightRequestModel request) async {
    final token = await _authRepository.getAccessToken();
    if (token == null) {
      return ApiResponse(
        isSuccess: false,
        message: 'Usuário não autenticado',
      );
    }

    final response = await _apiClient.request<FreightRequestResponse>(
      method: 'POST',
      path: ApiRoutes.freightRequest,
      body: request.toJson(),
      requiresAuth: true,
      fromJsonT: (json) => FreightRequestResponse.fromJson(json['data']),
    );

    return response;
  }

  Future<ApiResponse<List<FreightRequestResponse>>> getClientFreights() async {
    final token = await _authRepository.getAccessToken();
    if (token == null) {
      return ApiResponse(
        isSuccess: false,
        message: 'Usuário não autenticado',
      );
    }

    final response = await _apiClient.request<List<FreightRequestResponse>>(
      method: 'GET',
      path: ApiRoutes.myRequests,
      requiresAuth: true,
      fromJsonT: (json) => (json['data'] as List)
          .map((item) => FreightRequestResponse.fromJson(item))
          .toList(),
    );

    return response;
  }
}
