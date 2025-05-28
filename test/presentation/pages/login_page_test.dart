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

void main() {
  late MockLoginController mockLoginController;
  late MockUserProvider mockUserProvider;

  setUp(() {
    mockLoginController = MockLoginController();
    mockUserProvider = MockUserProvider();
    when(mockLoginController.isLoading).thenReturn(false);
  });

  Widget createLoginPage() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<LoginController>.value(
            value: mockLoginController),
        ChangeNotifierProvider<UserProvider>.value(value: mockUserProvider),
      ],
      child: const MaterialApp(
        home: LoginPage(),
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
  });

  group('LoginPage - Integração com Controller', () {
    testWidgets('deve chamar login com credenciais válidas',
        (WidgetTester tester) async {
      when(mockLoginController.isLoading).thenReturn(false);

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

      // Verificar se o controller foi chamado
      verify(mockLoginController.login(
        email: 'teste@teste.com',
        password: 'Teste@123',
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
  });
}
