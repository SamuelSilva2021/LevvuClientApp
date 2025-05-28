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
              Selector<LoginController, bool>(
                selector: (_, controller) => controller.isLoading,
                builder: (_, isLoading, __) {
                  return PrimaryButton(
                    label: AppStrings.login,
                    onPressed: isLoading ? null : _login,
                    isLoading: isLoading,
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

  void _login() {
    if (!_formKey.currentState!.validate()) return;

    _loginController.login(
      email: _emailController.text,
      password: _passwordController.text,
      navigateToHome: _navigateToHome,
      scaffoldKey: _scaffoldKey,
      context: context,
    );
  }

  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }
}
