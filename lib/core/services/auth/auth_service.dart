import 'dart:convert';
import 'package:levvu_client/core/models/auth_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class AuthService {
  static const String _authKey = 'auth_data';
  final SharedPreferences _prefs;

  AuthService(this._prefs);

  Future<void> saveAuthData(AuthModel authData) async {
    debugPrint('💾 Salvando dados de autenticação...');
    final json = authData.toJson();
    debugPrint('📦 Dados a serem salvos: $json');
    await _prefs.setString(_authKey, jsonEncode(json));
    debugPrint('✅ Dados salvos com sucesso');

    // Verifica se os dados foram salvos corretamente
    final savedData = await getAuthData();
    debugPrint('🔍 Dados salvos verificados: ${savedData?.toJson()}');
  }

  Future<AuthModel?> getAuthData() async {
    debugPrint('📖 Buscando dados de autenticação...');
    final json = _prefs.getString(_authKey);
    if (json == null) {
      debugPrint('❌ Nenhum dado de autenticação encontrado');
      return null;
    }

    debugPrint('📖 Dados de autenticação encontrados: $json');
    try {
      final Map<String, dynamic> data = jsonDecode(json);
      debugPrint('📦 Parsing AuthModel from JSON: $data');
      final authData = AuthModel.fromJson(data);
      return authData;
    } catch (e) {
      debugPrint('❌ Erro ao parsear dados de autenticação: $e');
      return null;
    }
  }

  Future<String?> getToken() async {
    final authData = await getAuthData();
    debugPrint(
        '🔑 Obtendo token: ${authData?.token != null ? 'Token encontrado' : 'Token não encontrado'}');
    return authData?.token;
  }

  Future<String?> getRefreshToken() async {
    final authData = await getAuthData();
    debugPrint(
        '🔄 Obtendo refresh token: ${authData?.refreshToken != null ? 'Token encontrado' : 'Token não encontrado'}');
    return authData?.refreshToken;
  }

  Future<bool> isAuthenticated() async {
    final authData = await getAuthData();
    final isAuth = authData != null && authData.token != null;
    debugPrint('🔒 Verificando autenticação: $isAuth');

    if (isAuth && authData!.isTokenExpired) {
      debugPrint('⚠️ Token expirado');
      await clearAuthData();
      return false;
    }

    return isAuth;
  }

  Future<void> clearAuthData() async {
    debugPrint('🧹 Limpando dados de autenticação...');
    //await _prefs.remove(_authKey);
    debugPrint('✅ Dados de autenticação removidos');
  }
}
