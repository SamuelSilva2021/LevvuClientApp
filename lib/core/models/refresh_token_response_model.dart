import 'package:levvu_client/core/models/user_model.dart';

class RefreshTokenResponseModel {
  final String token;
  final String refreshToken;
  final DateTime tokenExpiration;
  final UserModel user;

  RefreshTokenResponseModel({
    required this.token,
    required this.refreshToken,
    required this.tokenExpiration,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'refreshToken': refreshToken,
      'tokenExpiration': tokenExpiration.toIso8601String(),
      'user': user.toJson(),
    };
  }

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final user = data['user'] as Map<String, dynamic>? ?? {};

    return RefreshTokenResponseModel(
      token: data['token']?.toString() ?? '',
      refreshToken: data['refreshToken']?.toString() ?? '',
      tokenExpiration: data['tokenExpiration'] != null
          ? DateTime.parse(data['tokenExpiration'].toString())
          : DateTime.now().add(const Duration(hours: 1)),
      user: UserModel.fromJson(user),
    );
  }
}
