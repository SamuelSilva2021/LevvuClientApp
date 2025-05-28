import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:levvu_client/core/constants/app_colors.dart';
import 'package:levvu_client/core/constants/app_strings.dart';
import 'package:levvu_client/core/utils/validators.dart';
import 'package:levvu_client/presentation/widgets/custom_text_field.dart';

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

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CustomTextField(
            controller: widget.nomeController,
            labelText: AppStrings.fullName,
            prefixIcon: Icons.person_outline,
            textCapitalization: TextCapitalization.words,
            keyboardType: TextInputType.name,
            validator: (value) => Validators.validateName(value),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.emailController,
            labelText: AppStrings.email,
            hintText: AppStrings.emailHint,
            prefixIcon: Icons.email_outlined,
            keyboardType: TextInputType.emailAddress,
            validator: (value) => Validators.validateEmail(value),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.telefoneController,
            labelText: AppStrings.phone,
            hintText: AppStrings.phoneHint,
            prefixIcon: Icons.phone_outlined,
            keyboardType: TextInputType.phone,
            inputFormatters: [Validators.telefoneMask],
            validator: (value) =>
                Validators.validatePhoneNumber(value, Validators.telefoneMask),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.cpfController,
            labelText: AppStrings.cpf,
            hintText: AppStrings.cpfHint,
            prefixIcon: Icons.badge_outlined,
            keyboardType: TextInputType.number,
            inputFormatters: [Validators.cpfMask],
            validator: (value) =>
                Validators.validateCPF(value, Validators.cpfMask),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.senhaController,
            labelText: AppStrings.password,
            hintText: AppStrings.passwordHint,
            prefixIcon: Icons.lock_outline,
            obscureText: _obscureSenha,
            suffixIcon: _obscureSenha
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
            onSuffixIconPressed: () =>
                setState(() => _obscureSenha = !_obscureSenha),
            validator: (value) => Validators.validatePassword(value),
          ),
          const SizedBox(height: 16),
          CustomTextField(
            controller: widget.confirmarSenhaController,
            labelText: AppStrings.confirmPassword,
            hintText: AppStrings.passwordHint,
            prefixIcon: Icons.lock_outline,
            obscureText: _obscureConfirmarSenha,
            suffixIcon: _obscureConfirmarSenha
                ? Icons.visibility_outlined
                : Icons.visibility_off_outlined,
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
