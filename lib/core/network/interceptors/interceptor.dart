
import 'package:levvu_client/core/network/api_client.dart';

abstract class Interceptor {
  Future<ApiResponse?> onRequest({
    required String method,
    required String path,
    required Map<String, String> headers,
    Map<String, dynamic>? body,
  });

  Future<ApiResponse?> onResponse({
    required int statusCode,
    required Map<String, String> headers,
    required String body,
  });

  Future<ApiResponse?> onError(dynamic error);
}
