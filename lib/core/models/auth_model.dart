import 'package:levvu_client/core/models/user_model.dart';
import 'package:flutter/foundation.dart';

class AuthModel {
  final String accessToken;
  final String refreshToken;
  final DateTime tokenExpiration;
  final UserModel user;

  AuthModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
    DateTime? tokenExpiration,
  }) : tokenExpiration =
            tokenExpiration ?? DateTime.now().add(const Duration(hours: 1));

  bool get isTokenExpired => DateTime.now().isAfter(tokenExpiration);

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenExpiration': tokenExpiration.toIso8601String(),
      'user': user.toJson(),
    };
  }

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    debugPrint('📦 Parsing AuthModel from JSON: $json');

    // Se o JSON já estiver no formato correto (salvo no SharedPreferences)
    if (json.containsKey('accessToken')) {
      return AuthModel(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
        tokenExpiration: DateTime.parse(json['tokenExpiration'] as String),
      );
    }

    // Se o JSON vier da API (com data e user aninhados)
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final user = data['user'] as Map<String, dynamic>? ?? {};

    return AuthModel(
      accessToken: data['token']?.toString() ?? '',
      refreshToken: data['refreshToken']?.toString() ?? '',
      user: UserModel.fromJson(user),
      tokenExpiration: data['tokenExpiration'] != null
          ? DateTime.parse(data['tokenExpiration'].toString())
          : null,
    );
  }
}
