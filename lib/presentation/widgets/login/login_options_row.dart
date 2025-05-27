import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_strings.dart';

class LoginOptionsRow extends StatelessWidget {
  final bool rememberMe;
  final ValueChanged<bool> onRememberMeChanged;
  final VoidCallback onForgotPassword;

  const LoginOptionsRow({
    super.key,
    required this.rememberMe,
    required this.onRememberMeChanged,
    required this.onForgotPassword,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: rememberMe,
          onChanged: (value) => onRememberMeChanged(value ?? false),
        ),
        const Text(AppStrings.rememberMe),
        const Spacer(),
        TextButton(
          onPressed: onForgotPassword,
          child: Text(AppStrings.forgotPassword),
        )
      ],
    );
  }
}
