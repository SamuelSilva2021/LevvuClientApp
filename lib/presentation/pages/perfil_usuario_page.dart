import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';
import 'package:levvu_client/core/provider/user_provider.dart';
import 'package:provider/provider.dart';

class PerfilUsuarioPage extends StatefulWidget {
  const PerfilUsuarioPage({super.key});

  @override
  State<PerfilUsuarioPage> createState() => _PerfilUsuarioPageState();
}

class _PerfilUsuarioPageState extends State<PerfilUsuarioPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nomeController;
  late TextEditingController _emailController;
  late TextEditingController _telefoneController;
  bool _editMode = false;
  bool _receberNotificacoesEmail = true;
  bool _receberNotificacoesWhatsapp = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Inicializar controllers vazios, serão preenchidos no didChangeDependencies
    _nomeController = TextEditingController();
    _emailController = TextEditingController();
    _telefoneController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Carregar dados do usuário do provider
    final userProvider = Provider.of<UserProvider>(context);

    // Atualizar controllers com dados do usuário
    _nomeController.text = userProvider.userName;
    _emailController.text = userProvider.userEmail;
    _telefoneController.text = userProvider.userPhone;

    // Carregar preferências de notificação
    if (userProvider.authData != null) {
      _receberNotificacoesEmail =
          userProvider.authData!.userData['emailNotifications'] ?? true;
      _receberNotificacoesWhatsapp =
          userProvider.authData!.userData['whatsappNotifications'] ?? true;
    }
  }

  @override
  void dispose() {
    _nomeController.dispose();
    _emailController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Meu Perfil'),
        actions: [
          IconButton(
            icon: Icon(_editMode ? Icons.close : Icons.edit),
            onPressed: () {
              setState(() {
                _editMode = !_editMode;
                // Se estiver saindo do modo de edição, restaurar valores originais
                if (!_editMode) {
                  _nomeController.text = userProvider.userName;
                  _telefoneController.text = userProvider.userPhone;
                  _receberNotificacoesEmail =
                      userProvider.authData?.userData['emailNotifications'] ??
                          true;
                  _receberNotificacoesWhatsapp = userProvider
                          .authData?.userData['whatsappNotifications'] ??
                      true;
                }
              });
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Foto de perfil
                      Center(
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 60,
                              backgroundColor:
                                  AppColors.primary.withOpacity(0.1),
                              child: Icon(
                                Icons.person,
                                size: 80,
                                color: AppColors.primary,
                              ),
                            ),
                            if (_editMode)
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
                        controller: _nomeController,
                        decoration: const InputDecoration(
                          labelText: 'Nome Completo',
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        readOnly: !_editMode,
                        // readOnly: true, // Email não pode ser alterado
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
                        controller: _emailController,
                        decoration: const InputDecoration(
                          labelText: 'E-mail',
                          prefixIcon: Icon(Icons.email_outlined),
                        ),
                        readOnly: !_editMode,
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
                        controller: _telefoneController,
                        decoration: const InputDecoration(
                          labelText: 'Telefone',
                          prefixIcon: Icon(Icons.phone_outlined),
                        ),
                        readOnly: !_editMode,
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
                            value: _receberNotificacoesEmail,
                            activeColor: AppColors.primary,
                            onChanged: _editMode
                                ? (value) {
                                    setState(() {
                                      _receberNotificacoesEmail =
                                          value ?? false;
                                    });
                                  }
                                : null,
                          ),
                          Expanded(
                            child: Text(
                              'Receber notificações e novidades por e-mail',
                              style: TextStyle(
                                color: _editMode
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
                            value: _receberNotificacoesWhatsapp,
                            activeColor: AppColors.primary,
                            onChanged: _editMode
                                ? (value) {
                                    setState(() {
                                      _receberNotificacoesWhatsapp =
                                          value ?? false;
                                    });
                                  }
                                : null,
                          ),
                          Expanded(
                            child: Text(
                              'Receber notificações por WhatsApp',
                              style: TextStyle(
                                color: _editMode
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
                        onPressed: _editMode ? () {} : null,
                        icon: const Icon(Icons.lock_outline),
                        label: const Text('ALTERAR SENHA'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Botão de salvar (apenas no modo de edição)
                      if (_editMode)
                        ElevatedButton(
                          onPressed: () {
                            _salvarPerfil(userProvider);
                          },
                          child: const Text('SALVAR ALTERAÇÕES'),
                        ),
                      const SizedBox(height: 16),

                      // Botão de sair
                      TextButton.icon(
                        onPressed: () {
                          _logout(userProvider);
                        },
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
            ),
    );
  }
  Future<void> _salvarPerfil(UserProvider userProvider) async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      
      try {
        // Atualizar perfil no provider
        await userProvider.updateUserProfile(
          fullName: _nomeController.text,
          phoneNumber: _telefoneController.text,
          whatsappNotifications: _receberNotificacoesWhatsapp,
          emailNotifications: _receberNotificacoesEmail,
        );
        
        // Sair do modo de edição
        setState(() {
          _editMode = false;
          _isLoading = false;
        });
        
        // Mostrar mensagem de sucesso
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Perfil atualizado com sucesso!'),
              backgroundColor: Colors.green,
            ),
          );
        }
      } catch (e) {
        // Tratar erro
        setState(() {
          _isLoading = false;
        });
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Erro ao atualizar perfil: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
  
  Future<void> _logout(UserProvider userProvider) async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      await userProvider.logout();
      
      // Navegar para a tela de login
      if (mounted) {
        Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer logout: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}


