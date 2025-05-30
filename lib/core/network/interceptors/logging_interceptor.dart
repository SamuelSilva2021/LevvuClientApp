import 'package:flutter/foundation.dart';
import 'package:levvu_client/core/network/api_client.dart';
import 'package:levvu_client/core/network/interceptors/interceptor.dart';

class LoggingInterceptor implements Interceptor {
  @override
  Future<ApiResponse?> onRequest({
    required String method,
    required String path,
    required Map<String, String> headers,
    Map<String, dynamic>? body,
  }) async {
    debugPrint('🌐 [REQUEST] $method $path');
    debugPrint('📦 Headers: $headers');
    if (body != null) {
      debugPrint('📦 Body: $body');
    }
    return null;
  }

  @override
  Future<ApiResponse?> onResponse({
    required int statusCode,
    required Map<String, String> headers,
    required String body,
  }) async {
    debugPrint('✅ [RESPONSE] Status: $statusCode');
    debugPrint('📦 Headers: $headers');
    debugPrint('📦 Body: $body');
    return null;
  }

  @override
  Future<ApiResponse?> onError(dynamic error) async {
    debugPrint('❌ [ERROR] $error');
    return null;
  }
}
