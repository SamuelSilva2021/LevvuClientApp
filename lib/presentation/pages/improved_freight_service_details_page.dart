import 'package:flutter/material.dart';
import 'package:levvu_client/core/models/cargo_item_model.dart';
import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/core/models/service_types.dart';
import 'package:levvu_client/presentation/widgets/freight/photo_upload.dart';
import 'package:levvu_client/presentation/widgets/freight/cargo_items_form.dart';
import 'package:levvu_client/presentation/widgets/loading_button.dart';
import 'package:levvu_client/presentation/widgets/confirmation_dialog.dart';
import 'package:levvu_client/presentation/widgets/error_dialog.dart';
import 'package:levvu_client/presentation/widgets/error_message.dart';
import 'package:levvu_client/presentation/widgets/success_message.dart';
import 'package:provider/provider.dart';
import 'package:levvu_client/core/controllers/freight_request_controller.dart';
import 'package:levvu_client/presentation/widgets/freight/improved_service_type_selector.dart';
import 'package:levvu_client/presentation/widgets/freight/dynamic_freight_details_form.dart';

class ImprovedFreightServiceDetailsPage extends StatefulWidget {
  final String pickupAddress;
  final String deliveryAddress;
  final String routeDistance;
  final String routeDuration;
  final VoidCallback? onServiceTypeChanged;
  final Function(int)? onStepChanged;

  const ImprovedFreightServiceDetailsPage({
    super.key,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.routeDistance,
    required this.routeDuration,
    this.onServiceTypeChanged,
    this.onStepChanged,
  });

  @override
  State<ImprovedFreightServiceDetailsPage> createState() => ImprovedFreightServiceDetailsPageState();
}

class ImprovedFreightServiceDetailsPageState extends State<ImprovedFreightServiceDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _cargoTypeController = TextEditingController();
  final _weightController = TextEditingController();
  final _volumeController = TextEditingController();
  final _pickupTimeController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _observationsController = TextEditingController();

  EServiceTypes? _selectedServiceType;
  VehicleType _selectedVehicleType = VehicleType.moto;
  bool _helpLoading = false;
  bool _disassemblyAssembly = false;
  bool _specialPackaging = false;
  DateTime? _selectedDate;
  final List<CargoItemModel> _cargoItems = [];
  final List<String> _photoUrls = [];
  int currentStep = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _cargoTypeController.dispose();
    _weightController.dispose();
    _volumeController.dispose();
    _pickupTimeController.dispose();
    _itemDescriptionController.dispose();
    _observationsController.dispose();
    super.dispose();
  }

  void _addCargoItem(CargoItemModel item) {
    setState(() {
      _cargoItems.add(item);
    });
  }

  void _removeCargoItem(int index) {
    setState(() {
      _cargoItems.removeAt(index);
    });
  }

  void _addPhoto(String url) {
    setState(() {
      _photoUrls.add(url);
    });
  }

  void _removePhoto(int index) {
    setState(() {
      _photoUrls.removeAt(index);
    });
  }

  String? _validateRequired(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  String? _validateNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Este campo é obrigatório';
    }
    if (double.tryParse(value) == null) {
      return 'Digite um número válido';
    }
    return null;
  }

  bool canProceedToNextStep() {
    switch (currentStep) {
      case 0:
        return _selectedServiceType != null;
      case 1:
        return _descriptionController.text.isNotEmpty &&
               _weightController.text.isNotEmpty &&
               _volumeController.text.isNotEmpty;
      case 2:
        return true; // Fotos são opcionais
      default:
        return false;
    }
  }

  void nextStep() {
    if (canProceedToNextStep()) {
      if (currentStep == 2) {
        _showConfirmationDialog();
      } else {
        setState(() {
          currentStep++;
        });
        widget.onStepChanged?.call(currentStep);
      }
    }
  }

  void previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      widget.onStepChanged?.call(currentStep);
    }
  }

  Future<void> _showConfirmationDialog() async {
    if (!mounted) return;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => ConfirmationDialog(
        title: 'Confirmar Solicitação',
        message: 'Deseja realmente criar esta solicitação de frete?',
        confirmText: 'Sim',
        cancelText: 'Não',
        onConfirm: () {
          Navigator.pop(context, true);
        },
      ),
    );

    if (confirmed == true) {
      await _submitForm();
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    final controller = context.read<FreightRequestController>();

    final request = FreightRequestModel(
      pickupAddress: widget.pickupAddress,
      deliveryAddress: widget.deliveryAddress,
      vehicleType: _selectedVehicleType,
      serviceType: _selectedServiceType!.label,
      description: _descriptionController.text,
      cargoType: _cargoTypeController.text,
      weight: double.parse(_weightController.text),
      volume: double.parse(_volumeController.text),
      withdrawalDate: _selectedDate ?? DateTime.now(),
      pickupTime: _pickupTimeController.text,
      helpLoading: _helpLoading,
      disassemblyAssembly: _disassemblyAssembly,
      specialPackaging: _specialPackaging,
      itemDescription: _itemDescriptionController.text,
      observations: _observationsController.text,
      photoUrls: _photoUrls,
      imageUrls: _photoUrls,
      cargoItems: _cargoItems,
    );

    final success = await controller.createFreightRequest(request);

    if (!success && mounted) {
      await _showErrorDialog(
          controller.error ?? 'Erro ao criar solicitação de frete');
    } else if (mounted) {
      Navigator.pop(context);
      Navigator.pop(context);
    }
  }

  Future<void> _showErrorDialog(String message) async {
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => ErrorDialog(
        title: 'Erro',
        message: message, 
        buttonText: 'OK',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FreightRequestController>(
      builder: (context, controller, child) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              // Conteúdo principal
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.error != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: ErrorMessage(
                            message: controller.error!,
                            onDismiss: controller.clearError,
                          ),
                        ),
                      if (controller.successMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: SuccessMessage(
                            message: controller.successMessage!,
                            onDismiss: controller.clearSuccessMessage,
                          ),
                        ),
                      
                      _buildStepContent(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStepContent() {
    switch (currentStep) {
      case 0:
        return _buildServiceTypeStep();
      case 1:
        return _buildDetailsStep();
      case 2:
        return _buildPhotosStep();
      default:
        return Container();
    }
  }

  void _onServiceTypeChanged(EServiceTypes? type) {
    setState(() {
      _selectedServiceType = type;
    });
    widget.onServiceTypeChanged?.call();
  }

  Widget _buildServiceTypeStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Selecione o Tipo de Serviço',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Escolha a categoria que melhor descreve o que você precisa transportar.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        
        ImprovedServiceTypeSelector(
          selectedType: _selectedServiceType,
          onTypeSelected: _onServiceTypeChanged,
        ),
      ],
    );
  }

  Widget _buildDetailsStep() {
    if (_selectedServiceType == null) {
      return const Center(
        child: Text('Selecione um tipo de serviço primeiro'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Detalhes do ${_selectedServiceType!.label}',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Preencha as informações específicas para este tipo de serviço.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        
        DynamicFreightDetailsForm(
          descriptionController: _descriptionController,
          cargoTypeController: _cargoTypeController,
          weightController: _weightController,
          volumeController: _volumeController,
          pickupTimeController: _pickupTimeController,
          itemDescriptionController: _itemDescriptionController,
          observationsController: _observationsController,
          selectedServiceType: _selectedServiceType!,
          onVehicleTypeChanged: (value) {
            setState(() {
              _selectedVehicleType = value;
            });
          },
          onHelpLoadingChanged: (value) {
            setState(() {
              _helpLoading = value;
            });
          },
          onDisassemblyAssemblyChanged: (value) {
            setState(() {
              _disassemblyAssembly = value;
            });
          },
          onSpecialPackagingChanged: (value) {
            setState(() {
              _specialPackaging = value;
            });
          },
          validator: _validateRequired,
          numberValidator: _validateNumber,
        ),
      ],
    );
  }

  Widget _buildPhotosStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Fotos e Itens Adicionais',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Adicione fotos para ajudar os transportadores a entender melhor o serviço.',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey.shade600,
          ),
        ),
        const SizedBox(height: 24),
        
        PhotoUpload(
          photoUrls: _photoUrls,
          onPhotoAdded: _addPhoto,
          onPhotoRemoved: _removePhoto,
        ),
        
        const SizedBox(height: 24),
        
        CargoItemsForm(
          items: _cargoItems,
          onAddItem: _addCargoItem,
          onRemoveItem: _removeCargoItem,
        ),
      ],
    );
  }
}

