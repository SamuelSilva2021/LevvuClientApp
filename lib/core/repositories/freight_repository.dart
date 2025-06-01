import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/core/models/freight_request_response_model.dart';
import 'package:levvu_client/core/repositories/auth_repository.dart';
import 'package:levvu_client/core/services/api/api_service.dart';

class FreightRepository {
  final ApiService _apiService;
  final AuthRepository _authRepository;

  FreightRepository({
    required ApiService apiService,
    required AuthRepository authRepository,
  })  : _apiService = apiService,
        _authRepository = authRepository;

  Future<List<FreightRequestResponse>> getClientFreights() async {
    final response = await _apiService.getClientFreights();
    return response.data ?? [];
  }

  Future<FreightRequestResponse> createFreightRequest(
      FreightRequestModel request) async {
    final response = await _apiService.createFreightRequest(request);
    return response.data!;
  }
}
