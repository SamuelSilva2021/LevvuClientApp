import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levvu_client/core/controllers/login_controller.dart';
import 'package:levvu_client/core/provider/user_provider.dart';
import 'package:levvu_client/core/services/api/api_service.dart';
import 'package:levvu_client/core/services/auth/auth_service.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([UserProvider, ApiService, AuthService])
import 'login_controller_test.mocks.dart';

void main() {
  late LoginController loginController;
  late MockUserProvider mockUserProvider;
  late MockApiService mockApiService;
  late MockAuthService mockAuthService;
  late BuildContext mockContext;
  late GlobalKey<ScaffoldMessengerState> mockScaffoldKey;

  setUp(() {
    mockUserProvider = MockUserProvider();
    mockApiService = MockApiService();
    mockAuthService = MockAuthService();
    mockContext = MockContext();
    mockScaffoldKey = GlobalKey<ScaffoldMessengerState>();

    loginController = LoginController();
  });

  group('LoginController - checkExistingSession', () {
    test('deve navegar para home quando autenticado', () async {
      when(mockAuthService.isAuthenticated()).thenAnswer((_) async => true);

      bool navigated = false;
      await loginController.checkExistingSession(() => navigated = true);

      expect(navigated, true);
      expect(loginController.isLoading, false);
      expect(loginController.errorMessage, null);
    });

    test('não deve navegar quando não autenticado', () async {
      when(mockAuthService.isAuthenticated()).thenAnswer((_) async => false);

      bool navigated = false;
      await loginController.checkExistingSession(() => navigated = true);

      expect(navigated, false);
      expect(loginController.isLoading, false);
      expect(loginController.errorMessage, null);
    });

    test('deve tratar erro ao verificar autenticação', () async {
      when(mockAuthService.isAuthenticated())
          .thenThrow(Exception('Erro de conexão'));

      bool navigated = false;
      await loginController.checkExistingSession(() => navigated = true);

      expect(navigated, false);
      expect(loginController.isLoading, false);
      expect(
          loginController.errorMessage, contains('Erro ao verificar sessão'));
    });
  });

  group('LoginController - login', () {
    test('deve retornar false quando email ou senha vazios', () async {
      final result = await loginController.login(
        context: mockContext,
        email: '',
        password: '',
        navigateToHome: () {},
        scaffoldKey: mockScaffoldKey,
      );

      expect(result, false);
      expect(
          loginController.errorMessage, 'Por favor, preencha todos os campos');
      expect(loginController.isLoading, false);
    });

    test('deve retornar true e atualizar dados quando login bem-sucedido',
        () async {
      when(mockApiService.login(any, any)).thenAnswer((_) async => ApiResponse(
            isSuccess: true,
            message: 'Login realizado com sucesso',
            data: null,
          ));

      final result = await loginController.login(
        context: mockContext,
        email: 'teste@teste.com',
        password: 'Teste@123',
        navigateToHome: () {},
        scaffoldKey: mockScaffoldKey,
      );

      expect(result, true);
      expect(loginController.errorMessage, null);
      expect(loginController.isLoading, false);
      verify(mockUserProvider.updateAuthData()).called(1);
    });

    test('deve retornar false e mostrar erro quando login falhar', () async {
      when(mockApiService.login(any, any)).thenAnswer((_) async => ApiResponse(
            isSuccess: false,
            message: 'Credenciais inválidas',
            data: null,
          ));

      final result = await loginController.login(
        context: mockContext,
        email: 'teste@teste.com',
        password: 'senha_errada',
        navigateToHome: () {},
        scaffoldKey: mockScaffoldKey,
      );

      expect(result, false);
      expect(loginController.errorMessage, 'Credenciais inválidas');
      expect(loginController.isLoading, false);
    });

    test('deve tratar erro de conexão', () async {
      when(mockApiService.login(any, any))
          .thenThrow(Exception('Erro de conexão'));

      final result = await loginController.login(
        context: mockContext,
        email: 'teste@teste.com',
        password: 'Teste@123',
        navigateToHome: () {},
        scaffoldKey: mockScaffoldKey,
      );

      expect(result, false);
      expect(loginController.errorMessage, contains('Erro ao realizar login'));
      expect(loginController.isLoading, false);
    });
  });

  group('LoginController - clearError', () {
    test('deve limpar mensagem de erro', () {
      loginController.errorMessage = 'Erro de teste';
      loginController.clearError();
      expect(loginController.errorMessage, null);
    });
  });
}

class MockContext extends Mock implements BuildContext {}
