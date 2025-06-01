import 'dart:convert';
import 'package:levvu_client/core/models/user_login_response_model.dart';
import 'package:levvu_client/core/models/user_enum.dart';

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
    final token = json['token'] as String;
    final tokenParts = token.split('.');
    final payload = jsonDecode(utf8.decode(base64Url.decode(tokenParts[1])));

    final user = UserLoginResponseModel(
      id: payload[
              'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/nameidentifier']
          as String,
      email: payload[
              'http://schemas.xmlsoap.org/ws/2005/05/identity/claims/emailaddress']
          as String,
      fullName:
          payload['http://schemas.xmlsoap.org/ws/2005/05/identity/claims/name']
              as String,
      phoneNumber: '', // Não disponível no token
      userType: EUserType.client, // Valor padrão
      acceptedTerm: true, // Valor padrão
      whatsappNotifications: true, // Valor padrão
      emailNotifications: true, // Valor padrão
      status: EUserStatusTypes.active, // Valor padrão
      profileId: '', // Não disponível no token
    );

    return AuthModel(
      token: token,
      refreshToken: json['refreshToken'] as String,
      tokenExpiration: DateTime.parse(json['tokenExpiration'] as String),
      user: user,
    );
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
