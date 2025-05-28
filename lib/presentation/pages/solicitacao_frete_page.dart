import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';
import 'package:levvu_client/core/constants/app_strings.dart';
import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/core/services/api/api_service.dart';
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
  final ApiService _apiService = ApiService();
  bool _isLoading = false;
  
  final _pickupAddressController = TextEditingController();
  final _deliveryAddressController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _observationsController = TextEditingController();
  
  // Estado para seleção de tipo de serviço
  String _selectedServiceType = '';
  
  // Estado para data e hora
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  
  // Estado para opções adicionais
  bool _helpLoading = false;
  bool _disassemblyAssembly = false;
  bool _specialPackaging = false;
  
  List<String> _photoUrls = [];

  @override
  void dispose() {
    _pickupAddressController.dispose();
    _deliveryAddressController.dispose();
    _itemDescriptionController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
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
    
    if (selectedDate != null) {
      setState(() {
        _selectedDate = selectedDate;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
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
    
    if (selectedTime != null) {
      setState(() {
        _selectedTime = selectedTime;
      });
    }
  }

  void _addPhoto() {
    // Aqui seria implementada a lógica para adicionar fotos
    // Usando câmera ou galeria
    setState(() {
      if (_photoUrls.length < 3) {
        _photoUrls.add(''); // Placeholder para uma nova foto
      }
    });
  }

  Future<void> _submitFreightRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    if (_selectedServiceType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, selecione um tipo de serviço'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Formatar hora para string no formato HH:MM:SS
      final formattedTime = '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}:00';
      
      // Criar modelo de solicitação
      final freightRequest = FreightRequestModel(
        pickupAddress: _pickupAddressController.text,
        deliveryAddress: _deliveryAddressController.text,
        serviceType: _selectedServiceType,
        withdrawalDate: _selectedDate,
        pickupTime: formattedTime,
        itemDescription: _itemDescriptionController.text,
        helpLoading: _helpLoading,
        disassemblyAssembly: _disassemblyAssembly,
        specialPackaging: _specialPackaging,
        observations: _observationsController.text,
        photoUrls: _photoUrls.where((url) => url.isNotEmpty).toList(),
      );

      // Enviar solicitação para a API
      final response = await _apiService.createFreightRequest(freightRequest);

      setState(() {
        _isLoading = false;
      });

      if (response.isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Solicitação enviada com sucesso!'),
            backgroundColor: AppColors.success,
          ),
        );
        
        // Opcional: Navegar para outra tela ou limpar o formulário
        _formKey.currentState!.reset();
        _pickupAddressController.clear();
        _deliveryAddressController.clear();
        _itemDescriptionController.clear();
        _observationsController.clear();
        setState(() {
          _selectedServiceType = '';
          _helpLoading = false;
          _disassemblyAssembly = false;
          _specialPackaging = false;
          _photoUrls = [];
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(response.message),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao enviar solicitação: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Solicitar Frete'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
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
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      controller: _pickupAddressController,
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
                      controller: _deliveryAddressController,
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
                          isSelected: _selectedServiceType == 'Pequeno',
                          onTap: () {
                            setState(() {
                              _selectedServiceType = 'Pequeno';
                            });
                          },
                        ),
                        ServiceTypeCard(
                          title: 'Médio',
                          icon: Icons.inventory_outlined,
                          isSelected: _selectedServiceType == 'Médio',
                          onTap: () {
                            setState(() {
                              _selectedServiceType = 'Médio';
                            });
                          },
                        ),
                        ServiceTypeCard(
                          title: 'Grande',
                          icon: Icons.local_shipping_outlined,
                          isSelected: _selectedServiceType == 'Grande',
                          onTap: () {
                            setState(() {
                              _selectedServiceType = 'Grande';
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
                            onTap: _selectDate,
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
                                    '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
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
                            onTap: _selectTime,
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
                                    '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
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
                      controller: _itemDescriptionController,
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
                      value: _helpLoading,
                      onChanged: (value) {
                        setState(() {
                          _helpLoading = value ?? false;
                        });
                      },
                    ),
                    CheckboxOption(
                      label: 'Desmontagem/Montagem',
                      value: _disassemblyAssembly,
                      onChanged: (value) {
                        setState(() {
                          _disassemblyAssembly = value ?? false;
                        });
                      },
                    ),
                    CheckboxOption(
                      label: 'Embalagem especial',
                      value: _specialPackaging,
                      onChanged: (value) {
                        setState(() {
                          _specialPackaging = value ?? false;
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
                          onTap: _addPhoto,
                        ),
                        SizedBox(width: 12),
                        if (_photoUrls.isNotEmpty)
                          PhotoUploadCard(
                            onTap: _addPhoto,
                            imageUrl: _photoUrls[0],
                          ),
                        SizedBox(width: 12),
                        if (_photoUrls.length > 1)
                          PhotoUploadCard(
                            onTap: _addPhoto,
                            imageUrl: _photoUrls[1],
                          ),
                      ],
                    ),
                    SizedBox(height: 24),
                    
                    // Observações
                    CustomTextField(
                      labelText: 'Observações',
                      hintText: 'Informações adicionais para o entregador',
                      controller: _observationsController,
                      keyboardType: TextInputType.multiline,
                    ),
                    
                    SizedBox(height: 24),
                    
                    // Botão de Ação
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitFreightRequest,
                      style: ElevatedButton.styleFrom(
                        minimumSize: Size(double.infinity, 50),
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
                      ),
                      child: Text(
                        'SOLICITAR ORÇAMENTOS',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
