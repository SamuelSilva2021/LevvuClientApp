import 'package:levvu_client/core/models/user_login_response_model.dart';
import 'package:levvu_client/core/services/jwt/jwt_service.dart';
import 'package:levvu_client/core/services/jwt/jwt_payload_converter.dart';
import 'package:flutter/foundation.dart';

class AuthModel {
  final String token;
  final String refreshToken;
  final DateTime tokenExpiration;
  final UserLoginResponseModel user;

  AuthModel({
    required this.token,
    required this.refreshToken,
    required this.tokenExpiration,
    required this.user,
  });

  bool get isTokenExpired => DateTime.now().isAfter(tokenExpiration);

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    try {
      final token = json['token'] as String;
      final payload = JwtService.decodePayload(token);
      final user = JwtPayloadConverter.convertToUser(payload);

      final refreshToken = json['refreshToken']?.toString();
      if (refreshToken == null || refreshToken.isEmpty) {
        throw const FormatException('Refresh token não encontrado ou inválido');
      }

      final tokenExpiration = json['tokenExpiration']?.toString();
      if (tokenExpiration == null) {
        throw const FormatException('Data de expiração do token não encontrada');
      }

      return AuthModel(
        token: token,
        refreshToken: refreshToken,
        tokenExpiration: DateTime.parse(tokenExpiration),
        user: user,
      );
    } catch (e) {
      debugPrint('❌ Erro ao processar dados de autenticação: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'tokenExpiration': tokenExpiration.toIso8601String(),
      'user': user.toJson(),
    };
  }
}
