import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:levvu_client/core/services/auth/auth_service.dart';
import 'package:levvu_client/core/models/api_response_model.dart';
import 'package:levvu_client/core/models/auth_model.dart';
import 'package:levvu_client/core/models/user_register_model.dart';

class ApiService {
  // static const String baseUrl = 'http://10.0.2.2:5006'; // Endereço para emulador Android
  static const String baseUrl = 'http://192.168.0.101:5006'; // Endereço para web ou iOS

  // Headers padrão para requisições
  static Map<String, String> _headers() {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
  }

  // Headers com token de autenticação
  // static Map<String, String> _authHeaders(String token) {
  //   return {
  //     'Content-Type': 'application/json',
  //     'Accept': 'application/json',
  //     'Authorization': 'Bearer $token',
  //   };
  // }

  // Método para registro de usuário
  static Future<ApiResponse<Map<String, dynamic>>> registerUser(UserRegisterModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: _headers(),
        body: jsonEncode(user.toJson()),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['data'] != null && 
            responseData['data']['token'] != null && 
            responseData['data']['refreshToken'] != null) {
          
          final userData = {
            'id': responseData['data']['userId'],
            'email': responseData['data']['email'],
            'fullName': user.fullName,
          };
          
          final authModel = AuthModel(
            accessToken: responseData['data']['token'],
            refreshToken: responseData['data']['refreshToken'],
            tokenExpiration: DateTime.now().add(const Duration(minutes: 60)),
            userData: userData,
          );
          
          await AuthService.saveAuthData(authModel);
        }

        return ApiResponse(
          isSuccess: responseData['isSuccess'] ?? true,
          message: responseData['message'] ?? 'Cadastro realizado com sucesso!',
          data: responseData['data'],
        );
      }else{
        return ApiResponse(
          isSuccess: false,
          message: responseData['message'] ?? 'Erro ao realizar cadastro',
        );
      }
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: 'Erro de conexão: ${e.toString()}',
      );
    }
  }

  static Future<ApiResponse<Map<String, dynamic>>> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: _headers(),
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        // Se o login for bem-sucedido, salvar tokens e dados do usuário
        if (responseData['data'] != null && 
            responseData['data']['token'] != null && 
            responseData['data']['refreshToken'] != null) {
          
          final userData = responseData['data']['user'] ?? {};
          
          final authModel = AuthModel(
            accessToken: responseData['data']['token'],
            refreshToken: responseData['data']['refreshToken'],
            tokenExpiration: DateTime.parse(responseData['data']['tokenExpiration'] ?? DateTime.now().add(const Duration(minutes: 60)).toIso8601String()),
            userData: userData,
          );
          
          await AuthService.saveAuthData(authModel);
        }
        
        return ApiResponse(
          isSuccess: responseData['isSuccess'] ?? true,
          message: responseData['message'] ?? 'Login realizado com sucesso!',
          data: responseData['data'],
        );
      } else {
        return ApiResponse(
          isSuccess: false,
          message: responseData['message'] ?? 'Erro ao realizar login',
        );
      }
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: 'Erro de conexão: ${e.toString()}',
      );
    }
  }

 // Método para renovar token
  static Future<ApiResponse<Map<String, dynamic>>> refreshToken(String refreshToken) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/refresh-token'),
        headers: _headers(),
        body: jsonEncode({
          'refreshToken': refreshToken,
        }),
      );

      final responseData = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return ApiResponse(
          isSuccess: responseData['isSuccess'] ?? true,
          message: responseData['message'] ?? 'Token renovado com sucesso!',
          data: responseData['data'],
        );
      } else {
        return ApiResponse(
          isSuccess: false,
          message: responseData['message'] ?? 'Erro ao renovar token',
        );
      }
    } catch (e) {
      return ApiResponse(
        isSuccess: false,
        message: 'Erro de conexão: ${e.toString()}',
      );
    }
  }
  
  // Método para verificar se o usuário está autenticado e renovar token se necessário
  static Future<bool> checkAndRefreshAuth() async {
    final authData = await AuthService.getAuthData();
    if (authData == null) {
      return false;
    }
    
    // Se o token estiver expirado, tentar renovar
    if (authData.isTokenExpired) {
      final response = await refreshToken(authData.refreshToken);
      
      if (response.isSuccess && response.data != null) {
        final newAuthModel = AuthModel(
          accessToken: response.data!['token'],
          refreshToken: response.data!['refreshToken'],
          tokenExpiration: DateTime.parse(response.data!['tokenExpiration']),
          userData: authData.userData,
        );
        
        await AuthService.saveAuthData(newAuthModel);
        return true;
      }
      
      // Se não conseguir renovar, fazer logout
      await AuthService.logout();
      return false;
    }
    
    return true;
  }
}
