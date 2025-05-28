import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';
import 'package:levvu_client/core/provider/user_provider.dart';
import 'package:levvu_client/presentation/widgets/profile/profile_form.dart';
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
          : ProfileForm(
              formKey: _formKey,
              nomeController: _nomeController,
              emailController: _emailController,
              telefoneController: _telefoneController,
              editMode: _editMode,
              receberNotificacoesEmail: _receberNotificacoesEmail,
              receberNotificacoesWhatsapp: _receberNotificacoesWhatsapp,
              onEmailNotificationsChanged: (value) {
                setState(() {
                  _receberNotificacoesEmail = value;
                });
              },
              onWhatsappNotificationsChanged: (value) {
                setState(() {
                  _receberNotificacoesWhatsapp = value;
                });
              },
              onAlterarSenha: () {
                // TODO: Implementar alteração de senha
              },
              onSalvar: () => _salvarPerfil(userProvider),
              onLogout: () => _logout(userProvider),
              isLoading: _isLoading,
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
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (route) => false);
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
