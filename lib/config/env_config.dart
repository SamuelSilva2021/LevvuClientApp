import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter/foundation.dart';
import 'dart:io' show Platform;

class EnvConfig {
  static bool _isInitialized = false;

  static final Map<String, String> _defaultValues = {
    'AUTH_API_PORT': '5006',
    'MAIN_API_PORT': '5003',
    'ENVIRONMENT': 'development',
    'DEBUG': 'true'
  };

  static bool get isEmulator {
    if (Platform.isAndroid) {
      try {
        final buildTags = Platform.environment['BUILD_TAGS'] ?? '';
        final buildType = Platform.environment['BUILD_TYPE'] ?? '';
        final buildFingerprint =
            Platform.environment['BUILD_FINGERPRINT'] ?? '';
        final buildHardware = Platform.environment['HARDWARE'] ?? '';
        final buildProduct = Platform.environment['PRODUCT'] ?? '';
        final buildDevice = Platform.environment['DEVICE'] ?? '';
        final buildModel = Platform.environment['MODEL'] ?? '';
        final buildManufacturer = Platform.environment['MANUFACTURER'] ?? '';
        final buildBrand = Platform.environment['BRAND'] ?? '';

        return buildTags.contains('test-keys') ||
            buildType.contains('userdebug') ||
            buildFingerprint.contains('test-keys') ||
            buildHardware.contains('goldfish') ||
            buildProduct.contains('sdk_gphone') ||
            buildDevice.contains('generic') ||
            buildModel.contains('sdk_gphone') ||
            buildManufacturer.contains('Google') ||
            buildBrand.contains('generic');
      } catch (e) {
        debugPrint('Erro ao verificar emulador: $e');
        return false;
      }
    }

    if (Platform.isWindows) {
      return false;
    }

    return false;
  }

  static String get _baseUrl {
    final String customBaseUrl = _getEnvValue('BASE_API_URL_FISICAL_DEVICE');
    final String defaultBaseUrl = _getEnvValue('BASE_API_URL_DEFAULT');

    if (isEmulator) {
      return _getEnvValue('BASE_API_URL_EMULATOR');
    }
    return customBaseUrl.isNotEmpty ? customBaseUrl : defaultBaseUrl;
  }

  static String _getEnvValue(String key) {
    if (!_isInitialized) {
      return _defaultValues[key] ?? '';
    }
    final value = dotenv.env[key] ?? _defaultValues[key] ?? '';
    print('🔑 Obtendo valor para $key: $value');
    return value;
  }

  static String get authApiUrl {
    final port = _getEnvValue('AUTH_API_PORT');
    return '${_baseUrl}:$port';
  }

  static String get mainApiUrl {
    final port = _getEnvValue('MAIN_API_PORT');
    return '${_baseUrl}:$port';
  }

  static String get environment => dotenv.env['ENVIRONMENT'] ?? 'development';
  static bool get isDebug => _getEnvValue('DEBUG') == 'true';
  static String get googleMapsApiKey => _getEnvValue('GOOGLE_MAPS_API_KEY');

  static Future<void> init() async {
    try {
      print('📂 Iniciando carregamento do arquivo .env...');

      // Tenta carregar o arquivo .env.development
      try {
        await dotenv.load(fileName: '.env.development');
        print('✅ Arquivo .env.development carregado com sucesso');
      } catch (e) {
        print('⚠️ Não foi possível carregar .env.development: $e');

        // Se não conseguir carregar .env.development, tenta carregar .env
        try {
          await dotenv.load(fileName: '.env');
          print('✅ Arquivo .env carregado com sucesso');
        } catch (e) {
          print('❌ Não foi possível carregar nenhum arquivo .env: $e');
          rethrow;
        }
      }

      _isInitialized = true;

      // Verifica se a API Key está presente
      final apiKey = googleMapsApiKey;
      if (apiKey.isEmpty) {
        print('❌ ERRO: Google Maps API Key não encontrada!');
        print(
            '⚠️ Verifique se o arquivo .env contém a chave GOOGLE_MAPS_API_KEY');
      } else {
        print('✅ Google Maps API Key encontrada');
      }

      print('🔧 Configurações carregadas:');
      print('🌐 Auth API URL: $authApiUrl');
      print('🌐 Main API URL: $mainApiUrl');
      print('🔧 Is Emulator: $isEmulator');
    } catch (e, stackTrace) {
      print('❌ Erro ao carregar configurações: $e');
      print('📚 Stack trace: $stackTrace');
      print('⚠️ Usando valores padrão');
      _isInitialized = false;
    }
  }
}
