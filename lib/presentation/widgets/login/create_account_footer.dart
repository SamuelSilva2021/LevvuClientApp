import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_strings.dart';

class CreateAccountFooter extends StatelessWidget {
  final VoidCallback onCreateAccount;

  const CreateAccountFooter({
    super.key,
    required this.onCreateAccount,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(AppStrings.noAccount),
        TextButton(
          onPressed: onCreateAccount,
          child: const Text(AppStrings.createAccount),
        ),
      ],
    );
  }
}
