import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';
import 'package:levvu_client/core/services/api/api_service.dart';
import 'package:levvu_client/core/models/user_register_model.dart';
import 'package:levvu_client/presentation/widgets/register/register_form.dart';
import 'package:levvu_client/presentation/widgets/register/register_options.dart';
import 'package:levvu_client/presentation/widgets/primary_button.dart';

class CadastroClientePage extends StatefulWidget {
  const CadastroClientePage({super.key});

  @override
  State<CadastroClientePage> createState() => _CadastroClientePageState();
}

class _CadastroClientePageState extends State<CadastroClientePage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _telefoneController = TextEditingController();
  final _cpfController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();
  bool _aceitaTermos = false;
  bool _receberNotificacoes = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    _cpfController.dispose();
    _senhaController.dispose();
    _confirmarSenhaController.dispose();
    super.dispose();
  }

  Future<void> _registrarUsuario() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_aceitaTermos) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Você precisa aceitar os termos para continuar'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userModel = UserRegisterModel(
        fullName: _nomeController.text,
        email: _emailController.text,
        phoneNumber: _telefoneController.text,
        cpf: _cpfController.text,
        password: _senhaController.text,
        confirmPassword: _confirmarSenhaController.text,
        isClient: true,
        isPartner: false,
        acceptedTerm: _aceitaTermos,
        whatsappNotifications: _receberNotificacoes,
        emailNotifications: _receberNotificacoes,
      );

      final response = await ApiService.registerUser(userModel);

      if (response.isSuccess) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: AppColors.success,
            ),
          );

          // Navegar para a tela de login após cadastro bem-sucedido
          Future.delayed(const Duration(seconds: 2), () {
            if (mounted) {
              Navigator.of(context).pop();
            }
          });
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(response.message),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao realizar cadastro: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Cliente'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Cabeçalho
              Text(
                'Crie sua conta',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                'Preencha os campos abaixo para se cadastrar',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
              const SizedBox(height: 24),

              // Formulário
              RegisterForm(
                formKey: _formKey,
                nomeController: _nomeController,
                emailController: _emailController,
                telefoneController: _telefoneController,
                cpfController: _cpfController,
                senhaController: _senhaController,
                confirmarSenhaController: _confirmarSenhaController,
              ),
              const SizedBox(height: 24),

              // Opções
              RegisterOptions(
                aceitaTermos: _aceitaTermos,
                receberNotificacoes: _receberNotificacoes,
                onAceitaTermosChanged: (value) =>
                    setState(() => _aceitaTermos = value),
                onReceberNotificacoesChanged: (value) =>
                    setState(() => _receberNotificacoes = value),
              ),
              const SizedBox(height: 24),

              // Botão de Cadastro
              PrimaryButton(
                label: 'CADASTRAR',
                onPressed: _isLoading ? null : _registrarUsuario,
                isLoading: _isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
