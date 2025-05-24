import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';
import 'package:levvu_client/core/services/api/api_service.dart';
import 'package:levvu_client/core/models/user_register_model.dart';
import 'package:levvu_client/core/utils/validators.dart';

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
  bool _obscureSenha = true;
  bool _obscureConfirmarSenha = true;
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
          child: Form(
            key: _formKey,
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
                
                // Campo de Nome Completo
                TextFormField(
                  controller: _nomeController,
                  decoration: const InputDecoration(
                    labelText: 'Nome Completo',
                    prefixIcon: Icon(Icons.person_outline),
                  ),
                  textCapitalization: TextCapitalization.words,
                  keyboardType: TextInputType.name,
                  validator:(value) => Validators.validateName(value),
                ),
                const SizedBox(height: 16),
                
                // Campo de E-mail
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(
                    labelText: 'E-mail',
                    hintText: 'Digite seu e-mail',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) => Validators.validateEmail(value),
                ),
                const SizedBox(height: 16),
                
                // Campo de Telefone
                TextFormField(
                  controller: _telefoneController,
                  decoration: const InputDecoration(
                    labelText: 'Celular',
                    hintText: '(99) 99999-9999',
                    prefixIcon: Icon(Icons.phone_outlined),
                  ),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [Validators.telefoneMask],
                  validator:(value) =>  Validators.validatePhoneNumber(value, Validators.telefoneMask),
                ),
                const SizedBox(height: 16),
                
                // Campo de CPF
                TextFormField(
                  controller: _cpfController,
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                    hintText: '999.999.999-99',
                    prefixIcon: Icon(Icons.badge_outlined),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [Validators.cpfMask],
                  validator: (value) => Validators.validateCPF(value, Validators.cpfMask),
                ),
                const SizedBox(height: 16),
                
                // Campo de Senha
                TextFormField(
                  controller: _senhaController,
                  obscureText: _obscureSenha,
                  decoration: InputDecoration(
                    labelText: 'Senha',
                    hintText: 'Digite sua senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureSenha ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureSenha = !_obscureSenha;
                        });
                      },
                    ),
                  ),
                  validator: (value) => Validators.validatePassword(value),
                ),
                const SizedBox(height: 16),
                
                // Campo de Confirmar Senha
                TextFormField(
                  controller: _confirmarSenhaController,
                  obscureText: _obscureConfirmarSenha,
                  decoration: InputDecoration(
                    labelText: 'Confirmar Senha',
                    hintText: 'Confirme sua senha',
                    prefixIcon: const Icon(Icons.lock_outline),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscureConfirmarSenha ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureConfirmarSenha = !_obscureConfirmarSenha;
                        });
                      },
                    ),
                  ),
                  validator: (value) => Validators.validatePasswordConfirm(value, _senhaController.text),
                ),
                const SizedBox(height: 24),
                
                // Termos e Condições
                Row(
                  children: [
                    Checkbox(
                      value: _aceitaTermos,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _aceitaTermos = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _aceitaTermos = !_aceitaTermos;
                          });
                        },
                        child: RichText(
                          text: TextSpan(
                            text: 'Li e aceito os ',
                            style: TextStyle(color: AppColors.textPrimary),
                            children: [
                              TextSpan(
                                text: 'Termos de Uso',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              TextSpan(
                                text: ' e ',
                                style: TextStyle(color: AppColors.textPrimary),
                              ),
                              TextSpan(
                                text: 'Política de Privacidade',
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                
                // Notificações
                Row(
                  children: [
                    Checkbox(
                      value: _receberNotificacoes,
                      activeColor: AppColors.primary,
                      onChanged: (value) {
                        setState(() {
                          _receberNotificacoes = value ?? false;
                        });
                      },
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _receberNotificacoes = !_receberNotificacoes;
                          });
                        },
                        child: Text(
                          'Desejo receber notificações e novidades por e-mail',
                          style: TextStyle(color: AppColors.textPrimary),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Botão de Cadastrar
                ElevatedButton(
                  onPressed: _isLoading ? null : _registrarUsuario,
                  child: _isLoading 
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text('CADASTRAR'),
                ),
                const SizedBox(height: 16),
                
                // Já tem conta
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Já tem uma conta? ',
                      style: TextStyle(color: AppColors.textSecondary),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Faça login',
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
