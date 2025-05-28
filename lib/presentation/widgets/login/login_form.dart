import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_strings.dart';
import 'package:levvu_client/core/utils/validators.dart';
import 'package:levvu_client/presentation/widgets/custom_text_field.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          CustomTextField(
            controller: widget.emailController,
            labelText: AppStrings.emailLabel,
            hintText: AppStrings.emailHint,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => Validators.validateEmail(value),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.passwordController,
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
        ],
      ),
    );
  }
}
