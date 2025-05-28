import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';

class ProfileForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController nomeController;
  final TextEditingController emailController;
  final TextEditingController telefoneController;
  final bool editMode;
  final bool receberNotificacoesEmail;
  final bool receberNotificacoesWhatsapp;
  final Function(bool) onEmailNotificationsChanged;
  final Function(bool) onWhatsappNotificationsChanged;
  final VoidCallback onAlterarSenha;
  final VoidCallback onSalvar;
  final VoidCallback onLogout;
  final bool isLoading;

  const ProfileForm({
    super.key,
    required this.formKey,
    required this.nomeController,
    required this.emailController,
    required this.telefoneController,
    required this.editMode,
    required this.receberNotificacoesEmail,
    required this.receberNotificacoesWhatsapp,
    required this.onEmailNotificationsChanged,
    required this.onWhatsappNotificationsChanged,
    required this.onAlterarSenha,
    required this.onSalvar,
    required this.onLogout,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Foto de perfil
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(
                        Icons.person,
                        size: 80,
                        color: AppColors.primary,
                      ),
                    ),
                    if (editMode)
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          padding: const EdgeInsets.all(8),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Informações pessoais
              Text(
                'Informações Pessoais',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Nome
              TextFormField(
                controller: nomeController,
                decoration: const InputDecoration(
                  labelText: 'Nome Completo',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                readOnly: !editMode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite seu nome completo';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // E-mail
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                  labelText: 'E-mail',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                readOnly: !editMode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite seu e-mail';
                  }
                  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Digite um e-mail válido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Telefone
              TextFormField(
                controller: telefoneController,
                decoration: const InputDecoration(
                  labelText: 'Telefone',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                readOnly: !editMode,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, digite seu telefone';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24),

              // Preferências
              Text(
                'Preferências',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Notificações por email
              Row(
                children: [
                  Checkbox(
                    value: receberNotificacoesEmail,
                    activeColor: AppColors.primary,
                    onChanged: editMode
                        ? (value) => onEmailNotificationsChanged(value ?? false)
                        : null,
                  ),
                  Expanded(
                    child: Text(
                      'Receber notificações e novidades por e-mail',
                      style: TextStyle(
                        color: editMode
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              // Notificações por WhatsApp
              Row(
                children: [
                  Checkbox(
                    value: receberNotificacoesWhatsapp,
                    activeColor: AppColors.primary,
                    onChanged: editMode
                        ? (value) =>
                            onWhatsappNotificationsChanged(value ?? false)
                        : null,
                  ),
                  Expanded(
                    child: Text(
                      'Receber notificações por WhatsApp',
                      style: TextStyle(
                        color: editMode
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Segurança
              Text(
                'Segurança',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 16),

              // Alterar senha
              OutlinedButton.icon(
                onPressed: editMode ? onAlterarSenha : null,
                icon: const Icon(Icons.lock_outline),
                label: const Text('ALTERAR SENHA'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
              const SizedBox(height: 24),

              // Botão de salvar (apenas no modo de edição)
              if (editMode)
                ElevatedButton(
                  onPressed: isLoading ? null : onSalvar,
                  child: isLoading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text('SALVAR ALTERAÇÕES'),
                ),
              const SizedBox(height: 16),

              // Botão de sair
              TextButton.icon(
                onPressed: isLoading ? null : onLogout,
                icon: const Icon(Icons.logout, color: Colors.red),
                label: const Text(
                  'SAIR DA CONTA',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
