import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';
import 'package:levvu_client/core/constants/app_strings.dart';
import 'package:levvu_client/presentation/widgets/checkbox_option.dart';
import 'package:levvu_client/presentation/widgets/custom_text_field.dart';
import 'package:levvu_client/presentation/widgets/photo_upload_card.dart';
import 'package:levvu_client/presentation/widgets/service_type_card.dart';

class SolicitacaoFretePage extends StatefulWidget {
  const SolicitacaoFretePage({super.key});

  @override
  State<SolicitacaoFretePage> createState() => _SolicitacaoFretePageState();
}

class _SolicitacaoFretePageState extends State<SolicitacaoFretePage> {
  final _formKey = GlobalKey<FormState>();
  
  // Controladores para os campos de texto
  final _enderecoRetiradaController = TextEditingController();
  final _enderecoEntregaController = TextEditingController();
  final _descricaoItensController = TextEditingController();
  final _observacoesController = TextEditingController();
  
  // Estado para seleção de tipo de serviço
  String _tipoServicoSelecionado = '';
  
  // Estado para data e hora
  DateTime _dataSelecionada = DateTime.now();
  TimeOfDay _horaSelecionada = TimeOfDay.now();
  
  // Estado para opções adicionais
  bool _ajudaCarregamento = false;
  bool _desmontagemMontagem = false;
  bool _embalagemEspecial = false;
  
  // Lista de fotos (URLs ou paths)
  List<String> _fotos = [];

  @override
  void dispose() {
    _enderecoRetiradaController.dispose();
    _enderecoEntregaController.dispose();
    _descricaoItensController.dispose();
    _observacoesController.dispose();
    super.dispose();
  }

  void _selecionarData() async {
    final DateTime? dataSelecionada = await showDatePicker(
      context: context,
      initialDate: _dataSelecionada,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (dataSelecionada != null) {
      setState(() {
        _dataSelecionada = dataSelecionada;
      });
    }
  }

  void _selecionarHora() async {
    final TimeOfDay? horaSelecionada = await showTimePicker(
      context: context,
      initialTime: _horaSelecionada,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.primary,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    
    if (horaSelecionada != null) {
      setState(() {
        _horaSelecionada = horaSelecionada;
      });
    }
  }

  void _adicionarFoto() {
    // Aqui seria implementada a lógica para adicionar fotos
    // Usando câmera ou galeria
    setState(() {
      if (_fotos.length < 3) {
        _fotos.add(''); // Placeholder para uma nova foto
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar Frete'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            // Navegação de volta
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {
              // Ação de notificações
            },
          ),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Ação de perfil
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Campos de endereço
                CustomTextField(
                  labelText: AppStrings.lebalPickUpAddress,
                  hintText: AppStrings.hintPickUpAddress,
                  prefixIcon: Icons.search,
                  controller: _enderecoRetiradaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe o endereço de retirada';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),
                CustomTextField(
                  labelText: AppStrings.labeDeliveryAddress,
                  hintText: AppStrings.hintDeliveryAddress,
                  prefixIcon: Icons.search,
                  controller: _enderecoEntregaController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Por favor, informe o endereço de entrega';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 8),

                // Mapa (placeholder)
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.map, size: 48, color: AppColors.primary),
                        SizedBox(height: 8),
                        Text(
                          'Mapa Interativo',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
                
                // Tipo de Serviço
                Text(
                  'Tipo de Serviço',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ServiceTypeCard(
                      title: 'Pequeno',
                      icon: Icons.inventory_2_outlined,
                      isSelected: _tipoServicoSelecionado == 'Pequeno',
                      onTap: () {
                        setState(() {
                          _tipoServicoSelecionado = 'Pequeno';
                        });
                      },
                    ),
                    ServiceTypeCard(
                      title: 'Médio',
                      icon: Icons.inventory_outlined,
                      isSelected: _tipoServicoSelecionado == 'Médio',
                      onTap: () {
                        setState(() {
                          _tipoServicoSelecionado = 'Médio';
                        });
                      },
                    ),
                    ServiceTypeCard(
                      title: 'Grande',
                      icon: Icons.local_shipping_outlined,
                      isSelected: _tipoServicoSelecionado == 'Grande',
                      onTap: () {
                        setState(() {
                          _tipoServicoSelecionado = 'Grande';
                        });
                      },
                    ),
                  ],
                ),
                SizedBox(height: 24),
                
                // Data e Hora
                Text(
                  'Data e Hora',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: _selecionarData,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.calendar_today, color: AppColors.icon, size: 20),
                              SizedBox(width: 8),
                              Text(
                                '${_dataSelecionada.day.toString().padLeft(2, '0')}/${_dataSelecionada.month.toString().padLeft(2, '0')}/${_dataSelecionada.year}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: InkWell(
                        onTap: _selecionarHora,
                        child: Container(
                          padding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time, color: AppColors.icon, size: 20),
                              SizedBox(width: 8),
                              Text(
                                '${_horaSelecionada.hour.toString().padLeft(2, '0')}:${_horaSelecionada.minute.toString().padLeft(2, '0')}',
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 24),
                
                // Detalhes da Carga
                CustomTextField(
                  labelText: 'Detalhes da Carga',
                  hintText: 'Descrição dos itens',
                  controller: _descricaoItensController,
                  keyboardType: TextInputType.multiline, 
                ),
                SizedBox(height: 24),

                // Opções Adicionais
                Text(
                  'Opções Adicionais',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                CheckboxOption(
                  label: 'Ajuda com carregamento',
                  value: _ajudaCarregamento,
                  onChanged: (value) {
                    setState(() {
                      _ajudaCarregamento = value ?? false;
                    });
                  },
                ),
                CheckboxOption(
                  label: 'Desmontagem/Montagem',
                  value: _desmontagemMontagem,
                  onChanged: (value) {
                    setState(() {
                      _desmontagemMontagem = value ?? false;
                    });
                  },
                ),
                CheckboxOption(
                  label: 'Embalagem especial',
                  value: _embalagemEspecial,
                  onChanged: (value) {
                    setState(() {
                      _embalagemEspecial = value ?? false;
                    });
                  },
                ),
                SizedBox(height: 24),
                
                // Adicionar Fotos
                Text(
                  'Adicionar Fotos',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    PhotoUploadCard(
                      onTap: _adicionarFoto,
                    ),
                    SizedBox(width: 12),
                    if (_fotos.isNotEmpty)
                      PhotoUploadCard(
                        onTap: _adicionarFoto,
                        imageUrl: _fotos[0],
                      ),
                    SizedBox(width: 12),
                    if (_fotos.length > 1)
                      PhotoUploadCard(
                        onTap: _adicionarFoto,
                        imageUrl: _fotos[1],
                      ),
                  ],
                ),
                SizedBox(height: 24),
                
                // Observações
                CustomTextField(
                  labelText: 'Observações',
                  hintText: 'Informações adicionais para o entregador',
                  controller: _observacoesController,
                  keyboardType: TextInputType.multiline,
                ),
                
                SizedBox(height: 24),
                
                // Botão de Ação
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Implementar lógica para solicitar orçamentos
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Solicitação enviada com sucesso!'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    }
                  },
                  child: Text('SOLICITAR ORÇAMENTOS'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
