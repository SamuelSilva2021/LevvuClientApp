import 'package:flutter/material.dart';
import 'package:levvu_client/app/app_router.dart';
import 'package:levvu_client/core/controllers/login_controller.dart';
import 'package:levvu_client/core/controllers/register_controller.dart';
import 'package:levvu_client/core/provider/user_provider.dart';
import 'package:levvu_client/core/theme/app_theme.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatelessWidget {
  const AppWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
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
  }
}
