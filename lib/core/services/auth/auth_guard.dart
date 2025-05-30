import 'package:flutter/material.dart';
import 'package:levvu_client/core/provider/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:levvu_client/core/models/user_model.dart';

/// Wrapper para verificar autenticação e redirecionar conforme necessário
class AuthGuard extends StatelessWidget {
  final Widget child;
  final String redirectRoute;
  final bool Function(UserProvider)? authorizationCheck;

  const AuthGuard({
    super.key,
    required this.child,
    this.redirectRoute = '/login',
    this.authorizationCheck,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        // Verificar se está carregando
        if (userProvider.isLoading) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Verificar se está autenticado
        if (!userProvider.isAuthenticated) {
          // Redirecionar para tela de login
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              redirectRoute,
              (route) => false,
            );
          });
          return Container(); // Widget temporário enquanto redireciona
        }

        // Verificar autorização específica (se fornecida)
        if (authorizationCheck != null && !authorizationCheck!(userProvider)) {
          // Redirecionar para tela de acesso negado ou home
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/acesso-negado',
              (route) => false,
            );
          });
          return Container(); // Widget temporário enquanto redireciona
        }

        // Se passou por todas as verificações, mostrar o conteúdo
        return child;
      },
    );
  }
}

/// Extensão para verificações de permissão
extension PermissionChecks on UserProvider {
  // Verificar se é cliente
  bool get isClientUser => isClient;

  // Verificar se é parceiro
  bool get isPartnerUser => isPartner;

  // Verificar se tem permissão para acessar área administrativa
  bool get isAdmin => authData?.user.userType == UserType.admin;

  // Verificar permissões específicas
  bool hasPermission(String permission) {
    // TODO: Implementar verificação de permissões quando necessário
    return false;
  }
}
