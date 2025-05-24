import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_strings.dart';
import 'package:levvu_client/core/controllers/login_controller.dart';
import 'package:levvu_client/core/utils/validators.dart';
import 'package:levvu_client/presentation/components/logo_header.dart';
import 'package:levvu_client/presentation/widgets/custom_text_field.dart';
import 'package:levvu_client/presentation/widgets/primary_button.dart';
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

  bool _obscurePassword = true;
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
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                const LogoHeader(),
                const SizedBox(height: 48),
                CustomTextField(
                  controller: _emailController,
                  labelText: AppStrings.emailLabel,
                  hintText: AppStrings.emailHint,
                  prefixIcon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => Validators.validateEmail(value),
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: _passwordController,
                  labelText: AppStrings.passwordLabel,
                  hintText: AppStrings.passwordHint,
                  prefixIcon: Icons.lock_outline,
                  obscureText: _obscurePassword,
                  suffixIcon: _obscurePassword
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                  onSuffixIconPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                  validator: (value) => Validators.validatePassword(value),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: _rememberMe,
                      onChanged: (value) =>
                          setState(() => _rememberMe = value ?? false),
                    ),
                    const Text(AppStrings.rememberMe),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: Text(AppStrings.forgotPassword),
                    )
                  ],
                ),
                const SizedBox(height: 24),
                //Fará a reconstrução somente do botão
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(AppStrings.noAccount),
                    TextButton(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/cadastro'),
                      child: const Text(AppStrings.createAccount),
                    ),
                  ],
                )
              ],
            ),
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
