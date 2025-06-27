import 'package:flutter/material.dart';
import 'package:levvu_client/core/services/auth/auth_guard.dart';
import 'package:levvu_client/core/provider/user_provider.dart';
import 'package:levvu_client/presentation/pages/acesso_negado.dart';
import 'package:levvu_client/presentation/pages/cadastro_cliente_page.dart';
import 'package:levvu_client/presentation/pages/historico_fretes_page.dart';
import 'package:levvu_client/presentation/pages/home_page.dart';
import 'package:levvu_client/presentation/pages/login_page.dart';
import 'package:levvu_client/presentation/pages/perfil_usuario_page.dart';
import 'package:levvu_client/presentation/pages/visualizacao_propostas_page.dart';
import 'package:levvu_client/presentation/pages/improved_freight_request_page.dart';
import 'package:provider/provider.dart';
import 'package:levvu_client/core/constants/asset_constants.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case '/home':
        return MaterialPageRoute(
          builder: (context) => const AuthGuard(
            child: HomePage(),
          ),
        );
      case '/cadastro':
        return MaterialPageRoute(builder: (_) => const CadastroClientePage());
      case '/solicitar-frete':
        return MaterialPageRoute(
          builder: (context) => AuthGuard(
            child: const ImprovedFreightRequestPage(),
            // Verificar se é cliente
            authorizationCheck: (userProvider) => userProvider.isClientUser,
          ),
        );
      case '/propostas':
        return MaterialPageRoute(
          builder: (context) => const AuthGuard(
            child: VisualizacaoPropostasPage(),
          ),
        );
      case '/historico':
        return MaterialPageRoute(
          builder: (context) => const AuthGuard(
            child: HistoricoFretesPage(),
          ),
        );
      case '/perfil':
        return MaterialPageRoute(
          builder: (context) => const AuthGuard(
            child: PerfilUsuarioPage(),
          ),
        );
      case '/acesso-negado':
        return MaterialPageRoute(builder: (_) => const AcessoNegadoPage());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('Rota não encontrada: ${settings.name}'),
            ),
          ),
        );
    }
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    try {
      // Pequeno atraso para mostrar a tela de splash
      await Future.delayed(const Duration(seconds: 2));

      if (!mounted) return;

      // Inicializar o provider de usuário
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.initialize();

      if (!mounted) return;

      // Verificar se o usuário está autenticado
      if (userProvider.isAuthenticated) {
        debugPrint('Usuário autenticado, redirecionando para home');
        Navigator.of(context).pushReplacementNamed('/home');
      } else {
        debugPrint('Usuário não autenticado, redirecionando para login');
        Navigator.of(context).pushReplacementNamed('/login');
      }
    } catch (e) {
      debugPrint('Erro ao inicializar aplicação: $e');
      if (mounted) {
        Navigator.of(context).pushReplacementNamed('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(
                  75), // Metade da largura para fazer um círculo perfeito
              child: Image.asset(
                AssetConstants.logo,
                width: 150,
                height: 150,
                fit: BoxFit.contain,
                colorBlendMode: BlendMode.srcOver,
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(height: 48),
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
