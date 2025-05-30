import 'package:flutter/material.dart';
import 'package:levvu_client/core/constants/app_colors.dart';
import 'package:levvu_client/core/constants/app_strings.dart';
import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/core/services/api/api_service.dart';
import 'package:levvu_client/core/services/places/places_service.dart';
import 'package:levvu_client/presentation/widgets/checkbox_option.dart';
import 'package:levvu_client/presentation/widgets/custom_text_field.dart';
import 'package:levvu_client/presentation/widgets/photo_upload_card.dart';
import 'package:levvu_client/presentation/widgets/service_type_card.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:math';

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

  // Estado para o mapa
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};
  LatLng? _pickupLocation;
  LatLng? _deliveryLocation;

  @override
  void dispose() {
    _pickupAddressController.dispose();
    _deliveryAddressController.dispose();
    _itemDescriptionController.dispose();
    _observationsController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
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
            colorScheme: const ColorScheme.light(
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

  void _updateMapMarkers() {
    final markers = <Marker>{};

    if (_pickupLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('pickup'),
          position: _pickupLocation!,
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
          infoWindow: const InfoWindow(title: 'Origem'),
        ),
      );
    }

    if (_deliveryLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('delivery'),
          position: _deliveryLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: const InfoWindow(title: 'Destino'),
        ),
      );
    }

    setState(() {
      _markers = markers;
    });

    // Ajustar a câmera para mostrar todos os marcadores
    if (_pickupLocation != null && _deliveryLocation != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          _getBoundsForMarkers(),
          50.0, // padding
        ),
      );
    } else if (_pickupLocation != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_pickupLocation!, 15),
      );
    } else if (_deliveryLocation != null) {
      _mapController?.animateCamera(
        CameraUpdate.newLatLngZoom(_deliveryLocation!, 15),
      );
    }
  }

  LatLngBounds _getBoundsForMarkers() {
    return LatLngBounds(
      southwest: LatLng(
        min(_pickupLocation!.latitude, _deliveryLocation!.latitude),
        min(_pickupLocation!.longitude, _deliveryLocation!.longitude),
      ),
      northeast: LatLng(
        max(_pickupLocation!.latitude, _deliveryLocation!.latitude),
        max(_pickupLocation!.longitude, _deliveryLocation!.longitude),
      ),
    );
  }

  Future<void> _submitFreightRequest() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_selectedServiceType.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
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
      final formattedTime =
          '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}:00';

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
          const SnackBar(
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
        title: const Text('Solicitar Frete'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
              // Ação de notificações
            },
          ),
          IconButton(
            icon: const Icon(Icons.person),
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
                    PlacesService.buildPlaceSearchField(
                      controller: _pickupAddressController,
                      hintText: AppStrings.hintPickUpAddress,
                      onPlaceSelected: (prediction) {
                        setState(() {
                          _pickupAddressController.text =
                              prediction.description!;
                          _pickupLocation = LatLng(
                            double.parse(prediction.lat!),
                            double.parse(prediction.lng!),
                          );
                          _updateMapMarkers();
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    PlacesService.buildPlaceSearchField(
                      controller: _deliveryAddressController,
                      hintText: AppStrings.hintDeliveryAddress,
                      onPlaceSelected: (prediction) {
                        setState(() {
                          _deliveryAddressController.text =
                              prediction.description!;
                          _deliveryLocation = LatLng(
                            double.parse(prediction.lat!),
                            double.parse(prediction.lng!),
                          );
                          _updateMapMarkers();
                        });
                      },
                    ),
                    const SizedBox(height: 8),

                    // Mapa
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: GoogleMap(
                          initialCameraPosition: const CameraPosition(
                            target: LatLng(-23.550520, -46.633308), // São Paulo
                            zoom: 12,
                          ),
                          onMapCreated: (controller) {
                            _mapController = controller;
                          },
                          markers: _markers,
                          myLocationEnabled: true,
                          myLocationButtonEnabled: true,
                          zoomControlsEnabled: true,
                          mapToolbarEnabled: false,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Tipo de Serviço
                    Text(
                      'Tipo de Serviço',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 24),

                    // Data e Hora
                    Text(
                      'Data e Hora',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: InkWell(
                            onTap: _selectDate,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.calendar_today,
                                      color: AppColors.icon, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_selectedDate.day.toString().padLeft(2, '0')}/${_selectedDate.month.toString().padLeft(2, '0')}/${_selectedDate.year}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: InkWell(
                            onTap: _selectTime,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.access_time,
                                      color: AppColors.icon, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${_selectedTime.hour.toString().padLeft(2, '0')}:${_selectedTime.minute.toString().padLeft(2, '0')}',
                                    style:
                                        Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Detalhes da Carga
                    CustomTextField(
                      labelText: 'Detalhes da Carga',
                      hintText: 'Descrição dos itens',
                      controller: _itemDescriptionController,
                      keyboardType: TextInputType.multiline,
                    ),
                    const SizedBox(height: 24),

                    // Opções Adicionais
                    Text(
                      'Opções Adicionais',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
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
                    const SizedBox(height: 24),

                    // Adicionar Fotos
                    Text(
                      'Adicionar Fotos',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        PhotoUploadCard(
                          onTap: _addPhoto,
                        ),
                        const SizedBox(width: 12),
                        if (_photoUrls.isNotEmpty)
                          PhotoUploadCard(
                            onTap: _addPhoto,
                            imageUrl: _photoUrls[0],
                          ),
                        const SizedBox(width: 12),
                        if (_photoUrls.length > 1)
                          PhotoUploadCard(
                            onTap: _addPhoto,
                            imageUrl: _photoUrls[1],
                          ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Observações
                    CustomTextField(
                      labelText: 'Observações',
                      hintText: 'Informações adicionais para o entregador',
                      controller: _observationsController,
                      keyboardType: TextInputType.multiline,
                    ),

                    const SizedBox(height: 24),

                    // Botão de Ação
                    ElevatedButton(
                      onPressed: _isLoading ? null : _submitFreightRequest,
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 50),
                        backgroundColor: AppColors.primary,
                        disabledBackgroundColor:
                            AppColors.primary.withOpacity(0.5),
                      ),
                      child: const Text(
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
              child: const Center(
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
