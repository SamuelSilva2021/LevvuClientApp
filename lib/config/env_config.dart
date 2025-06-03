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
      return true;
    }

    return false;
  }

  static String get _baseUrl {
    final customBaseUrl = _getEnvValue('BASE_API_URL_FISICAL_DEVICE');
    if (isEmulator) {
      return 'http://10.0.2.2';
    }
    return customBaseUrl.isNotEmpty ? customBaseUrl : 'http://192.168.0.100';
  }

  static String _getEnvValue(String key) {
    if (!_isInitialized) {
      return _defaultValues[key] ?? '';
    }
    return dotenv.env[key] ?? _defaultValues[key] ?? '';
  }

  static String get authApiUrl {
    final port = _getEnvValue('AUTH_API_PORT');
    return '${_baseUrl}:$port';
  }

  static String get mainApiUrl {
    final port = _getEnvValue('MAIN_API_PORT');
    return '${_baseUrl}:$port';
  }

  static String get environment => _getEnvValue('ENVIRONMENT');
  static bool get isDebug => _getEnvValue('DEBUG') == 'true';

  static Future<void> init() async {
    try {
      if (kDebugMode) {
        await dotenv.load(fileName: '.env.development');
      } else {
        await dotenv.load(fileName: '.env.production');
      }
      _isInitialized = true;
      print('Arquivo .env carregado com sucesso');
      print('Auth API URL: $authApiUrl');
      print('Main API URL: $mainApiUrl');
      print('Is Emulator: $isEmulator');
    } catch (e) {
      print('Erro ao carregar arquivo .env: $e');
      print('Usando valores padrão');
      _isInitialized = false;
    }
  }
}
