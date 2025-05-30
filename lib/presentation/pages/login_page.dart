import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_strings.dart';
import 'package:levvu_client/core/controllers/login_controller.dart';
import 'package:levvu_client/presentation/widgets/login/logo_header.dart';
import 'package:levvu_client/presentation/widgets/primary_button.dart';
import 'package:levvu_client/presentation/widgets/login/login_options_row.dart';
import 'package:levvu_client/presentation/widgets/login/create_account_footer.dart';
import 'package:levvu_client/presentation/widgets/login/login_form.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldMessengerState>();

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _rememberMe = false;

  late LoginController _loginController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loginController = Provider.of<LoginController>(context, listen: false);
      _loginController.checkExistingSession(_navigateToHome);
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldKey,
      child: Scaffold(
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              const SizedBox(height: 120),
              const LogoHeader(),
              const SizedBox(height: 48),
              LoginForm(
                formKey: _formKey,
                emailController: _emailController,
                passwordController: _passwordController,
              ),
              const SizedBox(height: 16),
              LoginOptionsRow(
                rememberMe: _rememberMe,
                onRememberMeChanged: (value) =>
                    setState(() => _rememberMe = value),
                onForgotPassword: () {
                  // TODO: Implementar recuperação de senha
                },
              ),
              const SizedBox(height: 24),
              Consumer<LoginController>(
                builder: (context, controller, _) {
                  return Column(
                    children: [
                      if (controller.errorMessage != null) ...[
                        Text(
                          controller.errorMessage!,
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 14,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                      ],
                      PrimaryButton(
                        label: AppStrings.login,
                        onPressed: controller.isLoading ? null : _login,
                        isLoading: controller.isLoading,
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 16),
              CreateAccountFooter(
                onCreateAccount: () =>
                    Navigator.of(context).pushNamed('/cadastro'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    final success = await _loginController.login(
      email: _emailController.text,
      password: _passwordController.text,
      navigateToHome: _navigateToHome,
      scaffoldKey: _scaffoldKey,
      context: context,
    );

    if (success && _rememberMe) {
      // TODO: Implementar persistência de credenciais
    }
  }
}
