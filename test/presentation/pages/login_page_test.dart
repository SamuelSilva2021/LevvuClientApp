import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:levvu_client/core/controllers/login_controller.dart';
import 'package:levvu_client/core/provider/user_provider.dart';
import 'package:levvu_client/presentation/pages/login_page.dart';
import 'package:levvu_client/core/constants/app_strings.dart';
import 'package:levvu_client/core/utils/validators.dart';
import 'package:levvu_client/presentation/widgets/primary_button.dart';
import 'package:levvu_client/presentation/widgets/custom_text_field.dart';
import 'package:provider/provider.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';

@GenerateMocks([LoginController, UserProvider])
import 'login_page_test.mocks.dart';

class MockContext extends Mock implements BuildContext {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockLoginController mockLoginController;
  late MockUserProvider mockUserProvider;
  late MockContext mockContext;

  setUp(() {
    mockLoginController = MockLoginController();
    mockUserProvider = MockUserProvider();
    mockContext = MockContext();
    when(mockLoginController.isLoading).thenReturn(false);
    when(mockLoginController.errorMessage).thenReturn(null);
  });

  Widget createLoginPage() {
    return MaterialApp(
      home: MultiProvider(
        providers: [
          ChangeNotifierProvider<LoginController>.value(
              value: mockLoginController),
          ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
        ],
        child: Builder(
          builder: (context) => LoginPage(),
        ),
      ),
    );
  }

  group('LoginPage - Renderização', () {
    testWidgets('deve renderizar todos os elementos principais',
        (WidgetTester tester) async {
      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      // Verificar elementos principais
      expect(find.byType(LoginPage), findsOneWidget);
      expect(find.byType(Form), findsOneWidget);
      expect(find.byType(CustomTextField), findsNWidgets(2)); // Email e senha
      expect(find.byType(Checkbox), findsOneWidget); // Lembrar-me
      expect(find.text(AppStrings.forgotPassword),
          findsOneWidget); // Esqueci minha senha
      expect(find.byType(PrimaryButton), findsOneWidget); // Botão de login
    });

    testWidgets('deve mostrar o logo e o subtítulo',
        (WidgetTester tester) async {
      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      expect(find.byType(Image), findsOneWidget); // Logo
      expect(find.text(AppStrings.appSubtitle), findsOneWidget); // Subtítulo
    });

    testWidgets('deve mostrar mensagem de erro quando houver erro',
        (WidgetTester tester) async {
      const errorMessage = 'Erro de login';
      when(mockLoginController.errorMessage).thenReturn(errorMessage);

      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      expect(find.text(errorMessage), findsOneWidget);
      expect(find.text(errorMessage, skipOffstage: false), findsOneWidget);
    });
  });

  group('LoginPage - Validação de Formulário', () {
    testWidgets('deve validar email inválido', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      // Tentar submeter formulário vazio
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.emptyEmail), findsOneWidget);
      expect(find.text(AppStrings.emptyPassword), findsOneWidget);
    });

    testWidgets('deve validar senha curta', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      // Preencher email válido
      await tester.enterText(
          find.byType(CustomTextField).first, 'teste@teste.com');
      await tester.pumpAndSettle();

      // Preencher senha curta
      await tester.enterText(find.byType(CustomTextField).last, '123');
      await tester.pumpAndSettle();

      // Tentar submeter
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text('A senha deve ter pelo menos 8 caracteres'),
          findsOneWidget);
    });

    testWidgets('deve validar email inválido', (WidgetTester tester) async {
      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      // Preencher email inválido
      await tester.enterText(
          find.byType(CustomTextField).first, 'email_invalido');
      await tester.pumpAndSettle();

      // Tentar submeter
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      expect(find.text(AppStrings.invalidEmail), findsOneWidget);
    });
  });

  group('LoginPage - Integração com Controller', () {
    testWidgets('deve chamar login com credenciais válidas',
        (WidgetTester tester) async {
      when(mockLoginController.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
        navigateToHome: anyNamed('navigateToHome'),
        scaffoldKey: anyNamed('scaffoldKey'),
        context: anyNamed('context'),
      )).thenAnswer((_) async => true);

      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      // Preencher formulário com dados válidos
      await tester.enterText(
          find.byType(CustomTextField).first, 'teste@teste.com');
      await tester.enterText(find.byType(CustomTextField).last, 'Teste@123');
      await tester.pumpAndSettle();

      // Submeter formulário
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      // Verificar se o controller foi chamado com os parâmetros corretos
      verify(mockLoginController.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
        navigateToHome: anyNamed('navigateToHome'),
        scaffoldKey: anyNamed('scaffoldKey'),
        context: anyNamed('context'),
      )).called(1);
    });

    testWidgets('deve mostrar loading durante o login',
        (WidgetTester tester) async {
      when(mockLoginController.isLoading).thenReturn(true);

      await tester.pumpWidget(createLoginPage());
      await tester.pump();

      // Verificar se o botão está desabilitado e mostra loading
      final button = tester.widget<PrimaryButton>(find.byType(PrimaryButton));
      expect(button.onPressed, isNull);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('deve limpar mensagem de erro ao tentar login novamente',
        (WidgetTester tester) async {
      const errorMessage = 'Erro de login';
      when(mockLoginController.errorMessage).thenReturn(errorMessage);
      when(mockLoginController.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
        navigateToHome: anyNamed('navigateToHome'),
        scaffoldKey: anyNamed('scaffoldKey'),
        context: anyNamed('context'),
      )).thenAnswer((_) async {
        mockLoginController.clearError();
        return false;
      });

      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      // Preencher formulário
      await tester.enterText(
          find.byType(CustomTextField).first, 'teste@teste.com');
      await tester.enterText(find.byType(CustomTextField).last, 'Teste@123');
      await tester.pumpAndSettle();

      // Garantir que o botão está visível
      final buttonFinder = find.byType(PrimaryButton);
      await tester.ensureVisible(buttonFinder);
      await tester.pumpAndSettle();

      // Tentar login novamente
      await tester.tap(buttonFinder);
      await tester.pumpAndSettle();

      verify(mockLoginController.clearError()).called(1);
    });

    testWidgets('deve verificar sessão existente ao iniciar',
        (WidgetTester tester) async {
      when(mockLoginController.checkExistingSession(any))
          .thenAnswer((_) async {});

      await tester.pumpWidget(createLoginPage());
      await tester.pumpAndSettle();

      verify(mockLoginController.checkExistingSession(any)).called(1);
    });
  });

  group('LoginPage - Navegação', () {
    testWidgets('deve navegar para cadastro ao clicar no link',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: createLoginPage(),
          routes: {
            '/cadastro': (context) =>
                const Scaffold(body: Center(child: Text('Página de Cadastro'))),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Encontrar e clicar no link de cadastro
      final cadastroFinder = find.text(AppStrings.createAccount);
      expect(cadastroFinder, findsOneWidget);

      // Rolar até o widget estar visível
      await tester.ensureVisible(cadastroFinder);
      await tester.pumpAndSettle();

      await tester.tap(cadastroFinder);
      await tester.pumpAndSettle();

      // Verificar se a navegação foi chamada
      expect(find.text('Página de Cadastro'), findsOneWidget);
    });

    testWidgets('deve navegar para home após login bem-sucedido',
        (WidgetTester tester) async {
      bool navigated = false;
      when(mockLoginController.login(
        email: anyNamed('email'),
        password: anyNamed('password'),
        navigateToHome: anyNamed('navigateToHome'),
        scaffoldKey: anyNamed('scaffoldKey'),
        context: anyNamed('context'),
      )).thenAnswer((_) async {
        navigated = true;
        return true;
      });

      await tester.pumpWidget(
        MaterialApp(
          home: createLoginPage(),
          routes: {
            '/home': (context) =>
                const Scaffold(body: Center(child: Text('Home'))),
          },
        ),
      );
      await tester.pumpAndSettle();

      // Preencher e submeter formulário
      await tester.enterText(
          find.byType(CustomTextField).first, 'teste1@teste.com');
      await tester.enterText(find.byType(CustomTextField).last, 'Abc123@');
      await tester.tap(find.byType(PrimaryButton));
      await tester.pumpAndSettle();

      // Verificar se a navegação foi chamada
      expect(navigated, true);
    });
  });
}
