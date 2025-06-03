import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/core/models/freight_request_response_model.dart';
import 'package:levvu_client/core/repositories/auth_repository.dart';
import 'package:levvu_client/core/services/api/api_service.dart';
import 'package:levvu_client/core/network/api_client.dart';

class FreightRepository {
  final ApiService _apiService;
  final AuthRepository _authRepository;
  final ApiClient _apiClient;

  FreightRepository({
    required ApiService apiService,
    required AuthRepository authRepository,
    required ApiClient apiClient,
  })  : _apiService = apiService,
        _authRepository = authRepository,
        _apiClient = apiClient;

  Future<List<FreightRequestResponse>> getClientFreights() async {
    final response = await _apiService.getClientFreights();
    return response.data ?? [];
  }

  Future<ApiResponse<FreightRequestModel>> createFreightRequest(
    FreightRequestModel request,
  ) async {
    return await _apiClient.request<FreightRequestModel>(
      method: 'POST',
      path: '/api/freight-requests',
      body: request.toJson(),
      requiresAuth: true,
      fromJsonT: (json) => FreightRequestModel.fromJson(json),
    );
  }
}
