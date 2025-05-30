import 'package:levvu_client/core/models/user_model.dart';

class RefreshTokenResponseModel {
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  RefreshTokenResponseModel({
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user.toJson(),
    };
  }

  factory RefreshTokenResponseModel.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};
    final user = data['user'] as Map<String, dynamic>? ?? {};

    return RefreshTokenResponseModel(
      accessToken: data['token']?.toString() ?? '',
      refreshToken: data['refreshToken']?.toString() ?? '',
      user: UserModel.fromJson(user),
    );
  }
}
