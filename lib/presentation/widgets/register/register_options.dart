import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_strings.dart';

class RegisterOptions extends StatelessWidget {
  final bool aceitaTermos;
  final bool receberNotificacoes;
  final ValueChanged<bool> onAceitaTermosChanged;
  final ValueChanged<bool> onReceberNotificacoesChanged;

  const RegisterOptions({
    super.key,
    required this.aceitaTermos,
    required this.receberNotificacoes,
    required this.onAceitaTermosChanged,
    required this.onReceberNotificacoesChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Checkbox(
              value: aceitaTermos,
              onChanged: (value) => onAceitaTermosChanged(value ?? false),
            ),
            Expanded(
              child: RichText(
                text: TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium,
                  children: [
                    TextSpan(
                      text: AppStrings.acceptTermsPart1,
                    ),
                    TextSpan(
                      text: AppStrings.termsOfUse,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: AppStrings.acceptTermsPart2,
                    ),
                    TextSpan(
                      text: AppStrings.privacyPolicy,
                      style: TextStyle(
                        color: Theme.of(context).primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Checkbox(
              value: receberNotificacoes,
              onChanged: (value) =>
                  onReceberNotificacoesChanged(value ?? false),
            ),
            Expanded(
              child: Text(
                AppStrings.notificationsText,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
