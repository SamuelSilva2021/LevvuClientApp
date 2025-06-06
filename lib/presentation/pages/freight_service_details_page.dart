import 'package:flutter/material.dart';
import 'package:levvu_client/core/models/cargo_item_model.dart';
import 'package:levvu_client/core/models/freight_request_model.dart';
import 'package:levvu_client/presentation/widgets/freight/freight_details_form.dart';
import 'package:levvu_client/presentation/widgets/freight/photo_upload.dart';
import 'package:levvu_client/presentation/widgets/freight/cargo_items_form.dart';
import 'package:levvu_client/presentation/widgets/loading_button.dart';
import 'package:levvu_client/presentation/widgets/confirmation_dialog.dart';
import 'package:levvu_client/presentation/widgets/error_dialog.dart';
import 'package:levvu_client/presentation/widgets/error_message.dart';
import 'package:levvu_client/presentation/widgets/success_message.dart';
import 'package:provider/provider.dart';
import 'package:levvu_client/core/controllers/freight_request_controller.dart';
import 'package:levvu_client/core/models/service_types.dart';
import 'package:levvu_client/presentation/widgets/freight/service_type_selector.dart';

class FreightServiceDetailsPage extends StatefulWidget {
  final String pickupAddress;
  final String deliveryAddress;
  final String routeDistance;
  final String routeDuration;

  const FreightServiceDetailsPage({
    super.key,
    required this.pickupAddress,
    required this.deliveryAddress,
    required this.routeDistance,
    required this.routeDuration,
  });

  @override
  State<FreightServiceDetailsPage> createState() => _FreightServiceDetailsPageState();
}

class _FreightServiceDetailsPageState extends State<FreightServiceDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _cargoTypeController = TextEditingController();
  final _weightController = TextEditingController();
  final _volumeController = TextEditingController();
  final _pickupTimeController = TextEditingController();
  final _itemDescriptionController = TextEditingController();
  final _observationsController = TextEditingController();

  EServiceTypes _selectedServiceType = EServiceTypes.residentialMoving;
  VehicleType _selectedVehicleType = VehicleType.moto;
  bool _helpLoading = false;
  bool _disassemblyAssembly = false;
  bool _specialPackaging = false;
  DateTime? _selectedDate;
  final List<CargoItemModel> _cargoItems = [];
  final List<String> _photoUrls = [];

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

  Future<void> _showConfirmationDialog() async {
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
      serviceType: _selectedServiceType.label,
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
    }
  }

  Future<void> _showErrorDialog(String message) async {
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Serviço'),
      ),
      body: Consumer<FreightRequestController>(
        builder: (context, controller, child) {
          return Form(
            key: _formKey,
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
                  ServiceTypeSelector(
                    selectedType: _selectedServiceType,
                    onTypeSelected: (type) {
                      setState(() {
                        _selectedServiceType = type;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  FreightDetailsForm(
                    descriptionController: _descriptionController,
                    cargoTypeController: _cargoTypeController,
                    weightController: _weightController,
                    volumeController: _volumeController,
                    pickupTimeController: _pickupTimeController,
                    itemDescriptionController: _itemDescriptionController,
                    observationsController: _observationsController,
                    selectedServiceType: _selectedServiceType,
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
                  const SizedBox(height: 24),
                  LoadingButton(
                    text: 'Criar Solicitação',
                    onPressed: _showConfirmationDialog,
                    isLoading: controller.isLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
} 