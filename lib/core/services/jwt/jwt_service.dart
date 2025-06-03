import 'dart:convert';
import 'package:flutter/foundation.dart';

class JwtService {
  static Map<String, dynamic> decodePayload(String token) {
    try {
      final tokenParts = token.split('.');

      if (tokenParts.length != 3) {
        throw const FormatException('Token JWT inválido: formato incorreto');
      }

      // Adiciona padding base64 se necessário
      String base64Payload = tokenParts[1];
      base64Payload += '=' * ((4 - base64Payload.length % 4) % 4);
      final payload = utf8.decode(base64Url.decode(base64Payload));

      return jsonDecode(utf8.decode(base64Url.decode(base64Payload)));
    } catch (e) {
      debugPrint('❌ Erro ao decodificar token JWT: $e');
      rethrow;
    }
  }

  static String? getClaimValue(Map<String, dynamic> payload, String claimType) {
    return payload[claimType]?.toString();
  }
}
