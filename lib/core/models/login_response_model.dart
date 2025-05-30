import 'package:levvu_client/core/models/user_response_model.dart';

class LoginResponseModel {
  final String token;
  final String refreshToken;
  final DateTime tokenExpiration;
  final UserResponseModel user;

  LoginResponseModel({
    required this.token,
    required this.refreshToken,
    required this.tokenExpiration,
    required this.user,
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      token: json['token'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenExpiration: DateTime.parse(json['tokenExpiration'] as String),
      user: UserResponseModel.fromJson(json['user'] as Map<String, dynamic>),
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
