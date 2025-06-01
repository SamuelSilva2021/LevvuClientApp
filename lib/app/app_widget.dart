import 'package:flutter/material.dart';
import 'package:levvu_client/app/app_router.dart';
import 'package:levvu_client/core/controllers/login_controller.dart';
import 'package:levvu_client/core/controllers/register_controller.dart';
import 'package:levvu_client/core/provider/user_provider.dart';
import 'package:levvu_client/core/theme/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:levvu_client/core/repositories/auth_repository.dart';
import 'package:levvu_client/core/services/api/api_service.dart';
import 'package:levvu_client/core/services/auth/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        final prefs = snapshot.data!;
        final authService = AuthService(prefs);
        final authRepository = AuthRepository(
          apiClient: ApiService().apiClient,
          authService: authService,
        );

        return MultiProvider(
          providers: [
            Provider<AuthRepository>.value(value: authRepository),
            ChangeNotifierProvider(
              create: (_) => UserProvider(authRepository),
            ),
            ChangeNotifierProvider(create: (_) => LoginController()),
            ChangeNotifierProvider(create: (_) => RegisterController()),
          ],
          child: MaterialApp(
            title: 'Levvu',
            theme: AppTheme.lightTheme,
            debugShowCheckedModeBanner: false,
            initialRoute: '/',
            onGenerateRoute: AppRouter.generateRoute,
          ),
        );
      },
    );
  }
}
