import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_strings.dart';
import 'package:levvu_client/core/utils/validators.dart';
import 'package:levvu_client/presentation/widgets/custom_text_field.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nomeController;
  final TextEditingController emailController;
  final TextEditingController telefoneController;
  final TextEditingController cpfController;
  final TextEditingController senhaController;
  final TextEditingController confirmarSenhaController;

  const RegisterForm({
    super.key,
    required this.formKey,
    required this.nomeController,
    required this.emailController,
    required this.telefoneController,
    required this.cpfController,
    required this.senhaController,
    required this.confirmarSenhaController,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool _obscureSenha = true;
  bool _obscureConfirmarSenha = true;

  final _telefoneMask = MaskTextInputFormatter(
    mask: '(##) #####-####',
    filter: {"#": RegExp(r'[0-9]')},
  );

  final _cpfMask = MaskTextInputFormatter(
    mask: '###.###.###-##',
    filter: {"#": RegExp(r'[0-9]')},
  );

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: widget.nomeController,
            label: AppStrings.fullName,
            hint: AppStrings.fullName,
            keyboardType: TextInputType.name,
            validator: (value) => Validators.validateName(value),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.emailController,
            label: AppStrings.email,
            hint: AppStrings.emailHint,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => Validators.validateEmail(value),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.telefoneController,
            label: AppStrings.phone,
            hint: AppStrings.phoneHint,
            keyboardType: TextInputType.phone,
            maskFormatter: _telefoneMask,
            validator: (value) =>
                Validators.validatePhoneNumber(value, _telefoneMask),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.cpfController,
            label: AppStrings.cpf,
            hint: AppStrings.cpfHint,
            keyboardType: TextInputType.number,
            maskFormatter: _cpfMask,
            validator: (value) => Validators.validateCPF(value, _cpfMask),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.senhaController,
            label: AppStrings.password,
            hint: AppStrings.passwordHint,
            obscureText: _obscureSenha,
            suffixIcon: Icon(_obscureSenha
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined),
            onSuffixIconPressed: () =>
                setState(() => _obscureSenha = !_obscureSenha),
            validator: (value) => Validators.validatePassword(value),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.confirmarSenhaController,
            label: AppStrings.confirmPassword,
            hint: AppStrings.passwordHint,
            obscureText: _obscureConfirmarSenha,
            suffixIcon: Icon(_obscureConfirmarSenha
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined),
            onSuffixIconPressed: () => setState(
                () => _obscureConfirmarSenha = !_obscureConfirmarSenha),
            validator: (value) => Validators.validatePasswordConfirm(
                value, widget.senhaController.text),
          ),
        ],
      ),
    );
  }
}
