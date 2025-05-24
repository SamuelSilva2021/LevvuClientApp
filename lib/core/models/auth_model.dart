class AuthModel {
  final String accessToken;
  final String refreshToken;
  final DateTime tokenExpiration;
  final Map<String, dynamic> userData;

  AuthModel({
    required this.accessToken,
    required this.refreshToken,
    required this.tokenExpiration,
    required this.userData,
  });

  bool get isTokenExpired => DateTime.now().isAfter(tokenExpiration);

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
      tokenExpiration: json['tokenExpiration'] != null 
          ? DateTime.parse(json['tokenExpiration']) 
          : DateTime.now(),
      userData: json['userData'] ?? {},
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'tokenExpiration': tokenExpiration.toIso8601String(),
      'userData': userData,
    };
  }
}