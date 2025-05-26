import 'dart:convert';
import 'package:levvu_client/core/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _authKey = 'auth_data';
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  // Armazenar dados de autenticação
  static Future<void> saveAuthData(AuthModel authModel) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_authKey, jsonEncode(authModel.toJson()));
  }

  // Recuperar dados de autenticação
  static Future<AuthModel?> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_authKey);
    return jsonString != null
        ? AuthModel.fromJson(jsonDecode(jsonString))
        : null;
  }

  static Future<String?> getAccessToken() async {
    final authData = await getAuthData();
    return authData?.accessToken;
  }

  // Verificar se o usuário está autenticado
  static Future<bool> isAuthenticated() async {
    final authModel = await getAuthData();
    if (authModel == null) {
      return false;
    }

    // Se o token estiver expirado, tentar renovar
    if (authModel.isTokenExpired) {
      final refreshed = await refreshToken();
      return refreshed;
    }

    return true;
  }

  // Renovar token usando refresh token
  static Future<bool> refreshToken() async {
    final authModel = await getAuthData();
    if (authModel == null || authModel.refreshToken.isEmpty) {
      return false;
    }

    try {
      // Implementar chamada para renovar token
      // Exemplo:
      // final response = await http.post(
      //   Uri.parse('$baseUrl/api/auth/refresh-token'),
      //   headers: {'Content-Type': 'application/json'},
      //   body: jsonEncode({'refreshToken': authModel.refreshToken}),
      // );

      // if (response.statusCode == 200) {
      //   final data = jsonDecode(response.body);
      //   final newAuthModel = AuthModel(
      //     accessToken: data['token'],
      //     refreshToken: data['refreshToken'],
      //     tokenExpiration: DateTime.parse(data['tokenExpiration']),
      //     userData: authModel.userData,
      //   );
      //
      //   await saveAuthData(newAuthModel);
      //   return true;
      // }

      // Por enquanto, retornar false até implementarmos o endpoint de refresh
      return false;
    } catch (e) {
      return false;
    }
  }

  // Fazer logout
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_authKey);
  }
}
