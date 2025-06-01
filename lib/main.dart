import 'package:flutter/material.dart';
import 'package:levvu_client/app/app_widget.dart';
import 'package:levvu_client/config/env_config.dart';

void main() async {
  try {
    WidgetsFlutterBinding.ensureInitialized();

    print('Iniciando configuração do ambiente...');
    await EnvConfig.init();

    // Debug prints
    print('Auth API URL: ${EnvConfig.authApiUrl}');
    print('Main API URL: ${EnvConfig.mainApiUrl}');
    print('Is Emulator: ${EnvConfig.isEmulator}');
    print('Environment: ${EnvConfig.environment}');

    runApp(const AppWidget());
  } catch (e, stackTrace) {
    print('Erro durante a inicialização: $e');
    print('Stack trace: $stackTrace');
    rethrow;
  }
}
